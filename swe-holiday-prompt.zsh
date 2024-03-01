#
# Stylizes your Zsh prompt by adding emojis to it whenever there is a Swedish holiday.
#
# To use, add the following to ~/.zshr
#   [ -f ~/.zsh/swe-holiday-prompt.zsh ] && source ~/.zsh/swe-holiday-prompt.zsh
#
autoload -U colors && colors

# Disable promptinit if it is loaded
(( $+functions[promptinit] )) && {promptinit; prompt off}

# Allow parameter and command substitution in the prompt
setopt PROMPT_SUBST

# Override PROMPT if it does not use the gitprompt function
[[ "$PROMPT" != *swe_prompt* ]] \
    && NEWPROMPT='$(swe_prompt)' \
    && NEWPROMPT+=$PROMPT \
    && PROMPT=$NEWPROMPT

# The hash map holding they dates and respective icon. map[date]=emoji
# The format of the map key (date) should be `date +"%m%d"`
typeset -A holidays

# Adds a range of dates to the map of emojis. Takes 3 arguments
# _add_range <start> <end> <emoji>
_add_range() {
  _year=$(date +"%Y")
  _starts=$(date -j -f "%Y%m%d" $_year$1 "+%s")
  _ends=$(date -j -f "%Y%m%d" $_year$2 "+%s")
  _icon=$3
  _count=$((($_ends-$_starts)/86400+1))
  for i in $(seq $_count); do
    _add_starts=$(($_starts+86400*($i-1)))
    _key=$(date -j -f "%s" $_add_starts +"%m%d")
    holidays[$_key]=$_icon
  done
}

# New year
_add_range 0101 0102 🤢

# Easter
_add_range 0322 0425 🐣

# TODO: Fettisdagen (tisdagen efter fastlagssöndagen) 🥯

# Våffeldagen
_add_range 0325 0326 🧇

# Valborgsmässoafton
_add_range 0430 0430 🔥

# 1a Maj
_add_range 0430 0430 🟥

# TODO: Kristi himmelfärdsdag (40 dagar efter påsk) 🕊️

# TODO: Pingst (10 dagar efter kristi himmelfärdsdagen) ✝️

# Midsommar (hela juni)
_add_range 0601 0605 🌼

# Sveriges nationaldag
_add_range 0606 0607 🇸🇪

# Midsommar (hela juni)
_add_range 0608 0631 ☀️

# Alla helgons dag (månadsskiftet oktober-november)
_add_range 1030 1102 👻

# Advent (slutet av november-december)
_add_range 1130 1201 🕯️

# Lucia
_add_range 1213 1213 👸

# Christmas
_add_range 1214 1223 🎄
_add_range 1224 1225 🎁 
_add_range 1226 1229 🎄
_add_range 1230 1230 🥳

# Main func
swe_prompt() {
  d=$(date +"%m%d")
  prompt="${holidays[$d]}"
  if [ ! -z $prompt ]; then
    prompt+="  "
  fi
  print "${prompt}"
}

