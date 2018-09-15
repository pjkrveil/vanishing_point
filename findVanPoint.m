%%% findVanPoint.m (for assn2_1)

function [] = findVanPoint(Img, gImg, thr, r_resol, peaks, fillgap, minLength, nBin)
    % Process the image w/ Canny Edge Detection
    eImg = edge(gImg,'Canny', thr);
    
    % Process the Hough transform
    [H, T, R] = hough(eImg, 'RhoResolution', r_resol);
    
    % Find peaks in the Hough transform of the image.
    P  = houghpeaks(H, peaks, 'threshold', ceil(0.3 * max(H(:))));
    
    % Find line
    lines = houghlines(eImg, T, R, P, 'FillGap', fillgap, 'MinLength', minLength);
    figure, imshow(Img), hold on

    % Make the 2-col Vector for saving the information of Line Segment
    lineSeg = zeros(length(lines), 2);
    x = get(gca, 'XLim');
    
    % Draw lines on the image
    for k = 1 : length(lines)
        xy = [lines(k).point1; lines(k).point2];
        
        % Calculate Coefficients and plot each line on the image
        coeff = polyfit([xy(1, 1), xy(2, 1)], [xy(1, 2), xy(2, 2)], 1);
        lineSeg(k, :) = coeff;
        plot(x, (coeff(1) * x + coeff(2)), 'Linewidth', 2, 'Color', 'green');
    end
    
    % Finding the candidate points of Vanishing Point
    intersect = [];
    
    for k = 1 : length(lineSeg)
        for l = 1 : length(lineSeg)
            if (l ~= k)
                x_intersect = fzero(@(x) polyval(lineSeg(k, :) - lineSeg(l, :), x), 3);
                y_intersect = polyval(lineSeg(k, :), x_intersect);
                
                % Saving the information about intersection
                intersect = [intersect; [x_intersect y_intersect]];
            end
        end
    end
    
    % Error Handling if there is no lines or only one line
    msg = 'There is no Hough lines or intersection between Hough lines.';
    
    if (length(intersect) < 2)
        error(msg);
    end
    
    [x_van, y_van] = sumrVanPoint(Img, intersect, 5);
    
    % Caculate the information about the image and bin
    imgSize = size(gImg);
    
    ImgW = imgSize(2);
    ImgH = imgSize(1);
    BinW = round(ImgW / nBin(2));
    BinH = round(ImgH / nBin(1));
    
    % Get the bin which is voted mostly
    [N, Xedges, Yedges] = ...
        histcounts2(intersect(:, 1),intersect(:, 2), ...
                    'BinWidth', [BinW BinH], ...
                    'XBinLimits', [0, ImgW], ...
                    'YBinLimits', [0, ImgH]);
                
    maxPoint = max(N(:));
    [xStep, yStep] = find(N == maxPoint);
    
    % Draw the grid line on the image
    for k = 1 : BinH : ImgH
        x = [1 ImgW];
        y = [k k];
        plot(x, y, 'Color', 'k', 'LineStyle', '-');
    end

    for k = 1 : BinW : ImgW
        x = [k k];
        y = [1 ImgH];
        plot(x, y, 'Color', 'k', 'LineStyle', '-');
    end

    % Draw the rectangle for the region where the Vanishing Point is
    pos = [Xedges(xStep) Yedges(yStep) BinW BinH];
    rectangle('Position', pos, 'FaceColor', [0 1 0 0.25], 'Linestyle', 'none');
    
    % Mark where the Vanishing Point is
    plot(x_van, y_van, 'x', 'Linewidth', 2, 'Color', 'r');
    
    hold off;
end

