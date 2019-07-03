function ywFindRelationship(leftIndex,rightIndex,index)
    global family;
    m1=find(leftIndex==index);
    for(i=1:length(m1))
        if(~ismember(family,rightIndex(m1(i))))
            family=[family rightIndex(m1(i))];
            ywFindRelationship(leftIndex,rightIndex,rightIndex(m1(i)));
        end
    end
    
    m2=find(rightIndex==index);
    for(i=1:length(m2))
        if(~ismember(family,leftIndex(m2(i))))
            family=[family leftIndex(m2(i))];
            ywFindRelationship(leftIndex,rightIndex,leftIndex(m2(i)));
        end
    end
end