#!/bin/tcsh

setenv study activeness_past_curr

foreach meas (area thickness volume)
  foreach hemi (lh rh)
    foreach dir ({$hemi}.{$meas}.{$study}.10.glmdir)
      mri_glmfit-sim \
        --glmdir {$dir} \
        --cache 3.0 abs \
        --cwp 0.05 \
        --2spaces
     end
  end
end
