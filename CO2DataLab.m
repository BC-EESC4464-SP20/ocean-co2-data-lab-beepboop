%% Sarah, Delaney, Rosa -- Add your names in a comment here at the beginning of the code!

% Instructions: Follow through this code step by step, while also referring
% to the overall instructions and questions from the lab assignment sheet.

%% 1. Read in the monthly gridded CO2 data from the .csv file
% The data file is included in your repository as �LDEO_GriddedCO2_month_flux_2006c.csv�
% Your task is to write code to read this in to MATLAB
% Hint: you can again use the function �readtable�, and use your first data lab code as an example.
CO2data = readtable('LDEO_GriddedCO2_month_flux_2006c.csv');

%% 2a. Create new 3-dimensional arrays to hold reshaped data
%Find each unique longitude, latitude, and month value that will define
%your 3-dimensional grid

longrid = unique(CO2data.LON); %finds all unique longitude values
latgrid = unique(CO2data.LAT); %<-- following the same approach, find all unique latitude values
monthgrid = unique(CO2data.MONTH); %<-- following the same approach, find all unique months

%Create empty 3-dimensional arrays of NaN values to hold your reshaped data
    %You can make these for any variables you want to extract - for this
    %lab you will need PCO2_SW (seawater pCO2) and SST (sea surface
    %temperature)
    
PCO2_SWgrid = NaN(length(latgrid),length(longrid),length(monthgrid));
SSTgrid = NaN(length(latgrid),length(longrid),length(monthgrid));

%% 2b. Pull out the seawater pCO2 (PCO2_SW) and sea surface temperature (SST)
%data and reshape it into your new 3-dimensional arrays

for i = 1:height(CO2data)
x = find (CO2data.LAT(i) == latgrid);
y = find (CO2data.LON(i) == longrid);
z = find (CO2data.MONTH(i) == monthgrid);
SSTgrid(x,y,z)=CO2data.SST(i);
end

for i = 1:height(CO2data)
x = find (CO2data.LAT(i) == latgrid);
y = find (CO2data.LON(i) == longrid);
z = find (CO2data.MONTH(i) == monthgrid);
PCO2_SWgrid(x,y,z)=CO2data.PCO2_SW(i);
end
  
    

%% 3a. Make a quick plot to check that your reshaped data looks reasonable
%Use the imagesc plotting function, which will show a different color for
%each grid cell in your map. Since you can't plot all months at once, you
%will have to pick one at a time to check - i.e. this example is just for
%January

imagesc(SSTgrid(:,:,5)-SSTgrid(:,:,12))



%% 3b. Now pretty global maps of one month of each of SST and pCO2 data.
%I have provided example code for plotting January sea surface temperature
%(though you may need to make modifications based on differences in how you
%set up or named your variables above).

figure(1)
worldmap world
contourfm(latgrid, longrid, SSTgrid(:,:,1),'linecolor','none');
cmocean('balance')
colorbar bone
geoshow('landareas.shp','FaceColor','black')
title('January Sea Surface Temperature (^oC)')

%Check that you can make a similar type of global map for another month
%and/or for pCO2 using this approach. Check the documentation and see
%whether you can modify features of this map such as the contouring
%interval, color of the contour lines, labels, etc.
%%
figure(2)
worldmap world
contourfm(latgrid, longrid, SSTgrid(:,:,5),'linecolor','none');
cmocean('balance')
colorbar bone %can comment out to make the countries black
geoshow('landareas.shp','FaceColor','black')
title('January Sea Surface Temperature (^oC)')


%% 4. Calculate and plot a global map of annual mean pCO2
PCO2SWAnnMean = nanmean(PCO2_SWgrid, 3);
imagesc(PCO2SWAnnMean)

figure(3)
worldmap world
contourfm(latgrid, longrid, PCO2SWAnnMean(:,:),'linecolor','none');
cmocean('balance')
colorbar bone %can comment out to make the countries black
geoshow('landareas.shp','FaceColor','black')
title('January Sea Surface Temperature (^oC)')
%% 5. Calculate and plot a global map of the difference between the annual mean seawater and atmosphere pCO2
PCO2_AIRgrid = NaN(length(latgrid),length(longrid),length(monthgrid));

for i = 1:height(CO2data)
x = find (CO2data.LAT(i) == latgrid);
y = find (CO2data.LON(i) == longrid);
z = find (CO2data.MONTH(i) == monthgrid);
PCO2_AIRgrid(x,y,z)=CO2data.PCO2_AIR(i);
end

PCO2AIRAnnMean = nanmean(PCO2_AIRgrid, 3);

DiffAnnMean = PCO2SWAnnMean - PCO2AIRAnnMean;

figure(4)
worldmap world
contourfm(latgrid, longrid, DiffAnnMean(:,:),'linecolor','none');
cmocean('balance')
colorbar bone %can comment out to make the countries black
geoshow('landareas.shp','FaceColor','black')
title('January Sea Surface Temperature (^oC)')

%% 6. Calculate relative roles of temperature and of biology/physics in controlling seasonal cycle

%Equation 1
SSTgridMean = nanmean(SSTgrid, 3);
TMean_rep = repmat(SSTgridMean,1,1,12);
PCO2atTmean = PCO2_SWgrid .* exp(0.0423*(TMean_rep - SSTgridMean));
%biological,, what was the pCO2 be if we hold it constant

%Equation 2
PCO2atTobs = PCO2SWAnnMean .* exp(0.0423*(SSTgridMean - TMean_rep));
%temperature,, 

%Equation 3
Tmax_bio = nanmax(PCO2atTmean,[],3);
Tmin_bio = nanmin(PCO2atTmean,[],3);
PCO2bio = Tmax_bio - Tmin_bio;

%Equation 4
Tmax_temp = nanmax(PCO2atTobs,[],3);
Tmin_temp = nanmin(PCO2atTobs,[],3);
PCO2temp = Tmax_temp - Tmin_temp;

%Equation 5
Relative_PCO2 = PCO2temp - PCO2bio;
%negative values where bio is stronger // positive values where temp is
%stronger


%% 7. Pull out and plot the seasonal cycle data from stations of interest
%Do for BATS, Station P, and Ross Sea (note that Ross Sea is along a
%section of 14 degrees longitude - I picked the middle point)


%% 8. Reproduce your own versions of the maps in figures 7-9 in Takahashi et al. 2002
% But please use better colormaps!!!
% Mark on thesese maps the locations of the three stations for which you plotted the
% seasonal cycle above

%<--
