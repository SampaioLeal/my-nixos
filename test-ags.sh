fd --full-path "./ags/$1" | entr -rz ags run ./ags/$1/app.tsx
