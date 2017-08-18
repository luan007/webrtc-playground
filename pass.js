function pass(renderer, camera, fshader, vshader, uniform) {
  var scene = new THREE.Scene();
  var target = new THREE.WebGLRenderTarget(
    window.innerWidth,
    window.innerHeight,
    { minFilter: THREE.LinearFilter, magFilter: THREE.NearestFilter }
  );
  var target2 = target.clone();
  var mat = new THREE.ShaderMaterial({
    uniforms: uniform,
    vertexShader: vshader,
    fragmentShader: fshader
  });
  var tobject = new THREE.Mesh(new THREE.PlaneGeometry(2, 2), mat);
  scene.add(tobject);

  var b = false;

  var obj = {
    uniform: uniform,
    target: target,
    render: function() {
      b = !b;
      var swap = target;
      target = target2;
      target2 = swap;
      obj.target = target;
      renderer.render(scene, camera, target);
    }
  };
  return obj;
}
