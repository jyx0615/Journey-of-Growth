float vector_length(PVector v1, PVector v2) { return dist(v1.x, v1.y, v2.x, v2.y); }
float vector_angle (PVector v1, PVector v2) { return atan2(v2.y - v1.y, v2.x - v1.x); }