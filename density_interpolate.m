% Import data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function density_interpolate (filename, x_resolution)
	printf ("Loading %s ...", filename)
	% tmp = load (filename);
	tmp = dlmread(filename, ',', 1, 0);
	% Expected data format, from QGID 3.2 Profile plugin
	% X[km] LAT[°] LON[°] Depth[m]  
	printf ("done\n")
	% First, we trim the last row, as contains repeated value for X (discontinuity problem for interpolation)
	N = length(tmp(:,1)) -1 ;
	tmp = tmp(1:N,:);

	size (tmp)
	% Then, we rearrange the data to a standard format:
	% X[km] Depth[m] LAT[°] LON[°] 
	data(:,1) = tmp (:,1);	% Depth   
	data(:,2) = tmp (:,2);  % Density
%	data(3,:) = tmp (2,:)   % Latitude
%	data(4,:) = tmp (3,:)   % Longitude

	% Now, we proceed to interpolate with the new resolution
	printf ("%d rows to be processed\n", N)
	xmax = max (data(:,1));
	xf = [0:x_resolution:xmax]';
	yf = interp1 (data(:,1), data(:,2), xf, "linear");	% spline tend to overshoot 

	printf ("Exporting interpolated data...\n")
	out(:,1) = xf;
	out(:,2) = yf;

	% Finally, we export the new data
	% TODO: trim extension
	% We extract the filename, to append suffix
	[fPath fName fExtension] = fileparts (filename)
	new_filename = strcat(fPath,"/",fName,"_interpolated.csv")
	dlmwrite(new_filename, out, 'delimiter', '\t');
	
% Export data
