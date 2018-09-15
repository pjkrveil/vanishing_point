%%% sumrVanPoint.m (for assn2_1)

function [x_van, y_van] = sumrVanPoint(Img, candidate, thres)
    limit_x = size(Img, 1);
    limit_y = size(Img, 2);
    length = size(candidate , 1);
  
    % Thresholding the candidate points
    for k = 1 : length
        x_van = candidate(k, 1);
        y_van = candidate(k, 2);
        
        for l = k + 1 : length
            temp_x = candidate(l, 1);
            temp_y = candidate(l, 2);
        
            if ((max(0, x_van - thres) <= temp_x && temp_x <= min(limit_x, x_van + thres) &&...
                    max(0, y_van - thres) <= temp_y && temp_y <= min(limit_y, y_van + thres)))
                candidate(l, 1) = x_van;
                candidate(l, 2) = y_van;
            end
        end
    end
    
    % Count the number of each candidate point
    unqcand_x = unique(candidate(:, 1));
    unqcand_y = unique(candidate(:, 2));
    
    count_x = histc(candidate(:, 1), unqcand_x);
    count_y = histc(candidate(:, 2), unqcand_y);
    
    x_cand = horzcat(unqcand_x, count_x);
    y_cand = horzcat(unqcand_y, count_y);

    
    % Finding the proper Vanishing Point by appearance number    
    max_cx = x_cand(1, 2);
    max_cy = y_cand(1, 2);
    
    for k = 2 : size(x_cand, 1)
        cx = x_cand(k, 2);
        
        if (cx > max_cx)
            for l = 2 : size(y_cand, 1)
                cy = y_cand(l, 2);
                
                if (cy > max_cy && k == l)
                    max_cx = cx;
                    max_cy = cy;
                    
                    x_van = x_cand(k, 1);
                    y_van = y_cand(k, 1);
                end
            end
        end
    end
end