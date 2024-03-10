

FOLDER=$1 
REMOTE_JSON=$2

# ./scraper.sh ../img/151 https://cdn.malie.io/file/malie-io/tcgl/export/index.json
URL_PATH='https://cdn.malie.io/file/malie-io/tcgl/export/';

_extract() {
  echo ${1} | base64 --decode | jq -r ${2};
}

create_directories() {
    
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
  echo "╿  ↯  📂 Create directories for images...  "  
  echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";

  mkdir -p "$FOLDER/foils";
  mkdir -p "$FOLDER/etches";

}

fetch_json() {
    
  if [[ -n $REMOTE_JSON ]]; then

    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
    echo "╿  ↯  📃 Fetching JSON ┃ $REMOTE_JSON  "  
    echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";

    JSON=$( curl $REMOTE_JSON );     # 🌐 remote JSON file
    # JSON=$( cat $REMOTE_JSON );      # 💻 local JSON file

    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
    echo "╿  ✔  📃 Recieved JSON, continuing to parse..."  
    echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";

  else

    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
    echo "╿  ↯  ⛔ No JSON Provided, not fetching"  
    echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";

  fi

}

download_images() {
    
  if [[ -n $JSON ]]; then

  local CURL_BATCH="";
  local LOOP_COUNT=0;

    local SET=$( jq -r '.' < <( echo $JSON ) );
    # echo $JSON;

    # we use base64 otherwise the JSON result is treated like a bunch of lines of text
    # echo $SET | jq -r '.[2:7][] | @base64' | while read CARD; do
    for CARD in $( echo $SET | jq -r '.[] | @base64' ); do

      # local FOIL=
      # echo $FOIL;
      local FOIL_TYPE=$( _extract $CARD '.foil.type' );
      # echo $FOIL_TYPE;

      # only continue if there's a foil image (some are null)
      if [[ $FOIL_TYPE != 'null' ]]; then

        # get the foil image value
        local FOIL_IMG=$( _extract $CARD '.images.tcgl.png.foil' );
        local ETCH_IMG=$( _extract $CARD '.images.tcgl.png.etch' );

        # get name/path parts
        local EXT="${FOIL_IMG##*.}";
        local SERIES=$( echo $FOIL_IMG | awk -F '/' '{print $(NF-1)}' );
        local NUMBER=$( echo $FOIL_IMG | awk -F '_' '{print $(NF-1)}' );
        local FOIL_NAME=$( echo "${FOIL_IMG##*/}" );
        local ETCH_NAME=$( echo "${ETCH_IMG##*/}" );
        
        # create new name/output
      #   local NAME="${NUMBER,,}_foil$SUFFIX.$EXT";
        local FOIL_OUTPUT="${FOLDER}foils/${FOIL_NAME}";
        local ETCH_OUTPUT="${FOLDER}etches/${ETCH_NAME}";

        echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
        echo "╿  ↯  🔻 Downloading ${FOIL_IMG##*/} -> ${FOIL_OUTPUT}..."
        echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";
        
        # download the source image
        CURL_BATCH="${CURL_BATCH}\\nurl=\"${FOIL_IMG}\"\\noutput=\"${FOIL_OUTPUT}\"\\n";
        if [[ $ETCH_IMG != 'null' ]]; then
          CURL_BATCH="${CURL_BATCH}\\nurl=\"${ETCH_IMG}\"\\noutput=\"${ETCH_OUTPUT}\"\\n";
        fi;

      fi

    done;

    echo "";
    echo -e "$CURL_BATCH" | curl --parallel --parallel-immediate --parallel-max 20 --config -;
    echo "";

    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
    echo "╿  ↯  ✅ Finished Downloading from ${REMOTE_JSON}  "  
    echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";

  else

    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
    echo "╿  ↯  ⛔ No JSON Provided, not downloading images"  
    echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";

  fi


}


# ======================================================================


upscale() {

  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
  echo "╿  ⇑  🔼 Upscaling / Converting ${FOLDER}  "  
  echo "├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";
  echo "│ ";

  for file in ${FOLDER}/foils/*.png; do

    # get filename for the image
    local FILENAME=$( echo "${file##*/}" | cut -f 1 -d '.' );
    local SUFFIX="up"

    # echo "┝ 🔼 Upscaling & Converting ${file##*/}..."

    # params for conversions
    # local mask_alpha="-alpha set -background none -channel A -evaluate multiply 8 +channel"
    # local mask_brightness=""
    # local desaturate="-modulate 100x0"
    # local downsize="-colorspace LAB -filter Lanczos2 -distort resize 50% -colorspace sRGB"
    # local remove_alpha="-background black -alpha remove -alpha off"
    # local foil_brightness="-channel RGB -brightness-contrast 63x73"

    # if [[ $FILENAME =~ .*etched.* ]]; then
    #   # only need to boost brightness on etched cards
    #   mask_brightness="-channel RGB -brightness-contrast 32x52"
    # fi

    # output for 4x masks
    local UPSCALED="${FOLDER}/masks/upscaled/${FILENAME}_${SUFFIX}.png";
    # output for 2x masks
    local UPSCALE_MASK2="${FOLDER}/masks/upscaled/${FILENAME}_2x.png";
    # output for 4x masks
    local UPSCALE_MASK4="${FOLDER}/masks/upscaled/${FILENAME}_4x.png";

    # echo "│  🟣 🔼 4️⃣   Upscaling Mask Image with realesrgan.py";
    python3 ~/Real-ESRGAN/inference_realesrgan.py -i ${file} --suffix ${SUFFIX} -o ${FOLDER}/masks/upscaled/

    # echo "│  🔵 🔼 4️⃣   Simplifying Mask image";
    convert ${UPSCALED} ${mask_alpha} ${mask_brightness} "${UPSCALE_MASK4}";

    # echo "│  🔵 🔽 2️⃣   Downsampling Mask image";
    convert ${UPSCALE_MASK4} ${desaturate} ${downsize} "${UPSCALE_MASK2}";

    # ======================================================================

    # output for 1x foils
    local OUTPUT_FOIL1="${FOLDER}/foils/${FILENAME}.png";
    # output for 2x foils
    local OUTPUT_FOIL2="${FOLDER}/foils/upscaled/${FILENAME}_2x.png";
    # output for 4x foils
    local OUTPUT_FOIL4="${FOLDER}/foils/upscaled/${FILENAME}_4x.png";

    # echo "│  ⚫ 1️⃣   Creating Greyscale image";
    convert ${file} ${desaturate} ${remove_alpha} ${foil_brightness} "${OUTPUT_FOIL1}";

    # echo "│  ⚫ 2️⃣   Creating Greyscale image";
    convert ${UPSCALED} ${desaturate} ${remove_alpha} ${foil_brightness} ${downsize} "${OUTPUT_FOIL2}";

    # echo "│  ⚫ 4️⃣   Creating Greyscale image";
    convert ${UPSCALED} ${desaturate} ${remove_alpha} ${foil_brightness} "${OUTPUT_FOIL4}";

  done;

  echo "┝━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
  echo "│  ⇑  ✅ Finish Upscaling / Converting ${FOLDER}"
  echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";

}

# ======================================================================

compress() {
    
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
  echo "╿  ⇄  🌐 Creating WebP for ${FOLDER}"  
  echo "├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";
  echo "│ ";

  shopt -s globstar nullglob;
  for file in ${FOLDER}/**/*.png; do

    echo "┝  🌐 converting ${file} to WebP image";
    cwebp "${file}" -m 6 -mt -q 56 -alpha_q 62 -quiet -o "${file%.png}.webp"

  done;
    
  echo "┝━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
  echo "│  ⇄  ✅ Finish WebP for ${FOLDER}"
  echo "└┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈";

}



time ( 

  create_directories

  fetch_json
  download_images

  # upscale
  compress

)
