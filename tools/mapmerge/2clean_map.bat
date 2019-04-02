SET z_levels=10
cd 

FOR %%f IN (../../maps/southern_cross/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/southern_cross/%%f.backup ../../maps/southern_cross/%%f ../../maps/southern_cross/%%f
)

pause
