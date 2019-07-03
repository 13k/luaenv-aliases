after_install autoalias

autoalias() {
  if [ "$STATUS" = 0 ]; then
    case "$VERSION_NAME" in
    *[0-9]-*)
      luaenv alias "${VERSION_NAME%-*}" --auto 2>/dev/null || true
      luaenv alias "${VERSION_NAME%%-*}" --auto 2>/dev/null || true
      ;;
    *.*.*)
      luaenv alias "${VERSION_NAME%.*}" --auto 2>/dev/null || true
      ;;
    esac
  fi
}
