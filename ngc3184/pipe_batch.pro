pro pipe_batch $
   , spec=spec $
   , cube=cube $
   , win=win $
   , all=all

; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
; TUNING
; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&

  working_dir = "../../ngc3184/"
  gname = 'ngc3184'
  tag = 'beta'

; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
; WINDOWS
; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&

  if keyword_set(win) or keyword_set(all) then begin

     make_vfield_windows $
        , working_dir + 'other_data/hi/ngc3184_things_mom1.fits' $
        , out_root = working_dir + 'masks/windows/ngc3184_hi' $
        , gname = 'ngc3184' $
        , window = 100. $
        , /hel_to_lsr $
        , /ms_to_kms $
        , /smooth

     make_flat_windows $
        , gname = 'ngc3184' $
        , out_root = working_dir + 'masks/windows/ngc3184_loweredge' $
        , /hel_to_lsr $
        , /ms_to_kms $
        , window = 1000. $
        , offset = -800.

     make_flat_windows $
        , gname = 'ngc3184' $
        , out_root = working_dir + 'masks/windows/ngc3184_upperedge' $
        , /hel_to_lsr $
        , /ms_to_kms $
        , window = 1000. $
        , offset = +800.

     mask_to_windows $
        , working_dir + 'masks/windows/ngc3184_mask.fits' $
        , out_root = working_dir + 'masks/windows/ngc3184_line' $
        , /ms_to_kms

  endif

; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
; REDUCE SPECTRA
; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&

  if keyword_set(spec) or keyword_set(all) then begin

     spectra_pipeline $
        , identifier = tag $
        , working_dir = working_dir $
        , orig_data_file = 'orig_data.txt' $
        , bad_data_file = 'bad_data.txt' $
        , ref_mask_file = 'masks/reference/ngc3184_on_mask.fits' $
        , window_root = $ 
        working_dir + $
        ['masks/windows/ngc3184_loweredge' $
         , 'masks/windows/ngc3184_hi' $
         , 'masks/windows/ngc3184_line' $
         , 'masks/windows/ngc3184_upperedge'] $
        , degree = 3 $     
        , show=1 $
        , /report $
        , smooth=[1,10]
     
  endif

; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
; MAKE CUBE
; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&

  if keyword_set(cube) or keyword_set(all) then begin

     cube_pipeline $
        , out_root = 'ngc3184' $
        , identifier = tag $
        , working_dir = working_dir $
        , orig_data_file = 'orig_data.txt' $
        , blank_window_root = $ 
        working_dir + $
        ['masks/windows/ngc3184_loweredge' $
         , 'masks/windows/ngc3184_upperedge'] $
        , mask_window_root = $
        working_dir + $
        ['../masks/windows/ngc3184_line' $
         ,'../masks/windows/ngc3184_hi' $ 
        ] $
        , degree = 3 $     
        , cal = 0 $
        , prev_cube = working_dir + 'cubes/_beta/ngc3184_beta.fits' $
        , prev_mask_2d =  $
        workign_dir + 'cubes/_beta/ngc3184_beta_bright_map.fits' $
        , prev_mask_3d = working_dir + 'cubes/_beta/ngc3184_beta_mask.fits' $
        , /show $         
        , /report
     
  endif

end
