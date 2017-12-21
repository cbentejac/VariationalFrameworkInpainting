%% Instruction
%  Computes the confidence mask in such a way, that pixels outside the given mask have confidence of 1.0
%  and inside the masked region confidence values gradually decay up to the given asymptotic value.

%  @param domain: 
%         Masked region
%         format: Matrix, with all entries either 0 or 1. 1 stands for the
%         pixel within inpainting domain, 0 stands for the known part of
%         image.
%  @param decay_time: 
%         Controls the speed of confidence values decay
%         format: scalar
%  @param asymptotic_value: 
%         Lower boundary for confidence values
%         format: scalar

% Return: confidence_mask
%         Matrix(image)

% This function need to call its auxiliary function <<distance2boundry>>
%% 
function confidence_mask=calculate_confidence_mask(domain,decay_time,asymptotic_value)
    if max(domain) == 255
        domain=domain/255;
    end
    index = (domain == 1);
    if decay_time>0
        dist=distance2boundry(domain);
        confidence_mask=dist;
        confidence_mask(index)=(1-asymptotic_value)*exp(-dist(index)/decay_time)+asymptotic_value;
    else
        confidence_mask=1-domain;
        confidence_mask(index)=asymptotic_value;
    end  
end
