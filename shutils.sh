# Reindex/rename files
for i in $(ls DSC_{8,9}*); do
  echo DSC_`printf %04d $(echo "${i:4:-4}-8000" | bc)`
done

j=1
for i in $(ls *png); do
  cp $i slice_yz-`printf %02d $j`.png
  j=$(echo "$j+1" | bc)
done

for i in $(ls -d *); do 
  for j in $(more $i/list.dat); do 
    scp -r user@remote:/path/$i/output_`printf %05d $j` $i/.
  done
done

# Find & replace a string in a bunch of file
grep -rl licence . | xargs sed -i 's/licence/license/g'

# Convert a PDF into a bunch of PNG files
pdfseparate presentation.pdf slide-%d.pdf
for i in $(ls slide*); do mv $i slide_`printf %02d ${i:6:-4}`.pdf; done
for i in $(ls slide*); do convert -verbose -density 200 -trim $i -quality 100 -sharpen 0x1.0 ${i%.pdf}.png; done

# Generate animation with ImageMagick
convert -delay 20 $(ls *png) animation.gif ; 
# and if you need a selection:
convert -delay 20 $(ls *png | head -n40) animation.gif

# Get the content of a remote directory (you will get only d3/ if you put n=3)
wget -r -nH --cut-dir=[n] --level=1 http://www.site.com/d1/d2/d3

# Reconfigure DHCP (seems useful when you encounter a DNS problem bound to your configuration)
sudo dhclient -v [net-interface]
