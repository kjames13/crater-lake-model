function d = convertToM(lat1, lon1, lat2, lon2) % generally used geo measurement function
    R = 6378.137; % radius of earth in KM
    dLat = lat2 * pi / 180 - lat1 * pi / 180; % convert to radians
    dLon = lon2 * pi / 180 - lon1 * pi / 180; % convert to radians
    a = sin(dLat/2) * sin(dLat/2) + cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon/2) * sin(dLon/2);
    c = 2 * atan(sqrt(a));
    d = (R * c) * 1000; % meters