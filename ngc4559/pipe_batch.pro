pro pipe_batch $
   , spec=spec $
   , cube=cube $
   , win=win $
   , all=all

; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
; TUNING
; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&

  working_dir = "../../ngc4559/"
  gname = 'ngc4559'
  tag = 'beta'

; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
; MAKE FITTING WINDOWS
; %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&

  if keyword_set(win) or keyword_set(all) then begin

     make_flat_windows $
        , out_root = working_dir + 'masks/windows/ngc4559_flat' $
        , gname = 'ngc4559' $
        , window = 300.

     make_flat_windows $
        , gname = 'ngc4559' $
        , out_root = working_dir + 'masks/windows/ngc4559_loweredge' $
        , /hel_to_lsr $
        , /ms_to_kms $
        , window = 1000. $
        , offset = -950.

     make_flat_windows $
        , gname = 'ngc4559' $
        , out_root = working_dir + 'masks/windows/ngc4559_upperedge' $
        , /hel_to_lsr $
        , /ms_to_kms $
        , window = 1000. $
        , offset = +950.

     mask_to_windows $
        , working_dir + 'masks/windows/ngc4559_mask.fits' $
        , out_root = working_dir + 'masks/windows/ngc4559_line' $
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
        , ref_mask_file = 'masks/reference/ngc4559_on_mask.fits' $
        , window_root = working_dir+ $ 
        ['masks/windows/ngc4559_loweredge' $
;         , 'masks/windows/ngc4559_flat' $
         , 'masks/windows/ngc4559_line' $
         , 'masks/windows/ngc4559_upperedge'] $
        , degree = 3 $     
        , /show $
        , /report $
        , smooth=[1,10]
     
  endif

  if keyword_set(cube) or keyword_set(all) then begin

     cube_pipeline $
        , out_root = 'ngc4559' $
        , working_dir = working_dir $
        , identifier = tag $
        , orig_data_file = 'orig_data.txt' $
        , blank_window_root = $ 
        working_dir + $
        ['masks/windows/ngc4559_loweredge' $
         , 'masks/windows/ngc4559_upperedge'] $
        , mask_window_root = $
        working_dir + $
        ['masks/windows/ngc4559_line'] $
        , degree = 3 $     
        , cal_pixel_gain=0 $
        , prev_cube = working_dir+'cubes/_beta/ngc4559_beta.fits' $
        , prev_mask_2d =  $
        working_dir+'cubes/_beta/ngc4559_beta_bright_map.fits' $
        , prev_mask_3d = working_dir+'cubes/_beta/ngc4559_beta_mask.fits' $
        , /show $
        , /report

  endif
 
end
