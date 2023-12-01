clear

global folder "/Users/akashshaji/Desktop/Shubham"
cd "/Users/akashshaji/Desktop/Shubham"

* Load the crop yield data from a CSV file
import delimited "$folder/crop_yield copy.csv", clear

* Renaming columns for clarity
rename state Region
rename crop_year Year
rename production Total_Production

* Group the crop data by Year and Region to get aggregate production values
collapse (sum) Total_Production (mean) annual_rainfall, by(Region Year)

save "$folder/crop_yield.dta", replace

* Load the underweight children data from an Excel file
import excel "$folder/reshaped_underweight_children_data.xlsx", firstrow clear

save "$folder/uw_child.dta", replace

* Merge the datasets on Region and Year
merge 1:1 Region Year using "$folder/crop_yield.dta"

drop if Region==("Andaman and Nicobar Islands" "Chandigarth" "Dadra and Nagar Haveli" "Daman and Diu" "Jharkhand" "Lakshadweep" "New Delhi" "Orissa" "Rajasthan" "Telengana" "Total" "Uttaranchal" "Delhi" "Odisha" "Uttarakhand")

drop if Region == "Andaman and Nicobar Islands" | ///
Region=="Chandigarth" | ///
Region == "Dadra and Nagar Haveli" | ///
Region == "Daman and Diu" | ///
Region == "Jharkhand" | ///
Region == "Lakshadweep" | ///
Region == "New Delhi" | ///
Region == "Orissa" | ///
Region == "Rajasthan" | ///
Region == "Telangana" | ///
Region == "Total" | ///
Region == "Uttaranchal" | ///
Region == "Delhi" | ///
Region == "Odisha" | ///
Region == "Uttarakhand"
drop if Region == "Chhattisgarh"

drop if Year<2000
drop if Year>2018

save "$folder/merged_data.dta", replace

// Regressions Analysis ///

regress Underweight_Children_Percentage Total_Production

ivreg Underweight_Children_Percentage (Total_Production=annual_rainfall)

regress Underweight_Children_Percentage Total_Production Year

encode Region, gen(Region_num)

xtset Region_num Year
xtreg Underweight_Children_Percentage Total_Production, fe

