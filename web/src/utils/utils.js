
export const isMobile = (obj) => {
  switch (obj.$vuetify.breakpoint.name) {
    case "xs":
    case "sm":
      return true;
    case "md":
    case "lg":
    case "xl":
      return false;
  }
  return false;
}