function [output]=readm70(filename)
%function to read the R- and GOF-values from JANA .ref-file
str = fileread(filename);

%names appear to be dependent on jana version. Code below accept both wR
%and Rw
%all the parameters in the m70 file is:
% _diffrn_reflns_number                    9070
% _diffrn_reflns_theta_min                 4.81
% _diffrn_reflns_theta_max                 70.92
% _diffrn_reflns_limit_h_min               -21
% _diffrn_reflns_limit_h_max               5
% _diffrn_reflns_limit_k_min               -15
% _diffrn_reflns_limit_k_max               13
% _diffrn_reflns_limit_l_min               -12
% _diffrn_reflns_limit_l_max               21
% _diffrn_reflns_av_R_equivalents          0.2165
% _diffrn_reflns_av_sigmaI/netI            0.0538
% _diffrn_reflns_theta_full                48.46
% _diffrn_measured_fraction_theta_max
% _diffrn_measured_fraction_theta_full     0.71
%
% _exptl_crystal_F_000                     2448
% _refine_ls_weighting_scheme              sigma
% _refine_ls_weighting_details             'w=1/(\s^2^(F)+0.0001F^2^)'
% _refine_ls_structure_factor_coef         F
% _reflns_threshold_expression             'I>3\s(I)'
% _refine_ls_extinction_method
%  'B-C type 2 (Becker & Coppens, 1974)'
% _refine_ls_number_constraints            11
% _refine_ls_number_restraints             0
% _reflns_number_total                     635
% _reflns_number_gt                        525
% _refine_ls_R_factor_gt                   0.1274
% _refine_ls_wR_factor_gt                  0.1030
% _refine_ls_R_factor_all                  0.1632
% _refine_ls_wR_factor_ref                 0.1052
% _refine_ls_number_reflns                 635
% _refine_ls_number_parameters             19
% _refine_ls_goodness_of_fit_ref           4.89
% _refine_ls_goodness_of_fit_gt            5.28
% _refine_ls_shift/su_max                  0.0333
% _refine_ls_shift/su_mean                 0.0057

varStr={'_refine_ls_R_factor_gt' ...
    '_refine_ls_wR_factor_gt'...
    '_refine_ls_R_factor_all'...
    '_refine_ls_wR_factor_all'...
    '_refine_ls_wR_factor_ref'...
    '_pd_proc_ls_prof_R_factor'...
    '_pd_proc_ls_prof_wR_factor'...
    '_pd_proc_ls_prof_wR_expected'...
    '_refine_ls_goodness_of_fit_all'...
    '_refine_ls_goodness_of_fit_ref'...
    '_refine_ls_goodness_of_fit_gt'...
    '_refine_ls_number_parameters'...
    '_refine_ls_number_constraints'...
    '_refine_ls_number_restraints'...
    '_reflns_number_total'...
    '_reflns_number_gt'...   %gt = greater than = observed reflection
    '_refine_ls_number_reflns'...
    '_diffrn_reflns_av_R_equivalents'};

for k=1:length(varStr)
    T = regexp(str, [varStr{k} '\s*(\S+)'], 'tokens');
    if isempty(T)==0
        fieldname=regexprep(varStr{k},'^_','');
        output.(fieldname)=str2double(T{1});
    end
end

end