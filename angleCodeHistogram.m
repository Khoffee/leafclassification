%Input:=Boundary image from getBoundary, number of line segments to
%approximate contour
%Output:=Vectors of Angles between line segments (radians), frequency in
%each bin(20 bins for rose output)
%Description:
%The Angle Code Histogram(ACH) is calculated by connecting points along the
%contour of the leaf and determining the angle between them
function [angles bincount]=angleCodeHistogram(b1,numSegments)
    %Getting Contour Points
    [row col]=find(b1);
    contour=bwtraceboundary(b1,[row(1) col(1)],'N',8,Inf,'counterclockwise');
    %Getting Total Number of Points
    [nrows ncols]=size(contour);

    %Setting Contour Fraction for Line Segments, determining step for line
    %segments
    fraction=numSegments;
    step=floor(nrows/fraction);

    %Calculating Angles between Adjacent Line Segments
    angles=[];
    currentAngle=0;
    currentStart=[0 0];
    currentEnd=[0 0];
    nextStart=[0 0];
    nextEnd=[0 0];
    for i=1:step:nrows
        currentStart=[contour(i,1) contour(i,2)];
        if (i+step*2)<=nrows
            currentEnd=[contour(i+step,1) contour(i+step,2)];
            nextStart=[currentEnd(1) currentEnd(2)];
            nextEnd=[contour(i+step*2,1) contour(i+step*2,2)];

            line1=normVector(currentStart,currentEnd);
            line2=normVector(nextStart,nextEnd);
            angle=getAngle(line1,line2);
            angles=[angles,getAngle(line1,line2)];
        end
    end


    
    [tout bincount]=rose(angles,20);
end

%Calculates Normalized Vector from two Endpoints
function nVec=normVector(startp,endp)
    vector=[endp(1)-startp(1) endp(2)-startp(2)];
    nVec=vector/norm(vector);
end

%Calculates angle between two Normalized Vectors
function angle=getAngle(v1,v2)
    dp=dot(v1,v2);
    angle=acos(dp);
    angle=abs(angle);
end