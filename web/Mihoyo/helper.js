function vector_length(v1, v2) {
    return Math.hypot(v2.x - v1.x, v2.y - v1.y);
}
function vector_angle(v1, v2) {
    return Math.atan2(v2.y - v1.y, v2.x - v1.x);
}