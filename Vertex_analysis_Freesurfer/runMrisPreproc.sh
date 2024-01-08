#!/bin/tcsh

setenv study activeness_past_curr

foreach hemi (lh rh)
  foreach smoothing (10 25)
    foreach meas (area volume thickness)
      mris_preproc --fsgd FSGD/{$study}.fsgd \
        --cache-in {$meas}.fwhm{$smoothing}.fsaverage \
	--target fsaverage \
	--hemi {$hemi} \
	--out {$hemi}.{$meas}.{$study}.{$smoothing}.mgh
    end
  end
end
