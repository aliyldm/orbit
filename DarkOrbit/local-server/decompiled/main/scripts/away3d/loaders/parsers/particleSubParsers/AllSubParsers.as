package away3d.loaders.parsers.particleSubParsers
{
   import away3d.loaders.parsers.particleSubParsers.geometries.SingleGeometrySubParser;
   import away3d.loaders.parsers.particleSubParsers.geometries.shapes.CubeShapeSubParser;
   import away3d.loaders.parsers.particleSubParsers.geometries.shapes.CylinderShapeSubParser;
   import away3d.loaders.parsers.particleSubParsers.geometries.shapes.ExternalShapeSubParser;
   import away3d.loaders.parsers.particleSubParsers.geometries.shapes.PlaneShapeSubParser;
   import away3d.loaders.parsers.particleSubParsers.geometries.shapes.SphereShapeSubParser;
   import away3d.loaders.parsers.particleSubParsers.materials.ColorMaterialSubParser;
   import away3d.loaders.parsers.particleSubParsers.materials.TextureMaterialSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleAccelerationNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleBezierCurveNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleBillboardNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleColorNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleFollowNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleInitialColorNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleOrbitNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleOscillatorNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticlePositionNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleRotateToHeadingNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleRotationalVelocityNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleScaleNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleSegmentedColorNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleSegmentedScaleNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleSpriteSheetNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleTimeNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleUVNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleVelocityNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.color.CompositeColorValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.fourD.FourDCompositeWithOneDValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.fourD.FourDCompositeWithThreeDValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.matrix.Matrix3DCompositeValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.oneD.OneDConstValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.oneD.OneDCurveValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.oneD.OneDRandomVauleSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.property.InstancePropertySubParser;
   import away3d.loaders.parsers.particleSubParsers.values.threeD.ThreeDCompositeValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.threeD.ThreeDConstValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.threeD.ThreeDCylinderValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.threeD.ThreeDSphereValueSubParser;
   
   public class AllSubParsers
   {
      
      public static const ALL_PARTICLE_NODES:Array = [ParticleTimeNodeSubParser,ParticleVelocityNodeSubParser,ParticleAccelerationNodeSubParser,ParticlePositionNodeSubParser,ParticleBillboardNodeSubParser,ParticleFollowNodeSubParser,ParticleScaleNodeSubParser,ParticleColorNodeSubParser,ParticleOscillatorNodeSubParser,ParticleRotationalVelocityNodeSubParser,ParticleOrbitNodeSubParser,ParticleBezierCurveNodeSubParser,ParticleSpriteSheetNodeSubParser,ParticleRotateToHeadingNodeSubParser,ParticleSegmentedColorNodeSubParser,ParticleInitialColorNodeSubParser,ParticleSegmentedScaleNodeSubParser,ParticleUVNodeSubParser];
      
      public static const ALL_GEOMETRIES:Array = [SingleGeometrySubParser];
      
      public static const ALL_MATERIALS:Array = [TextureMaterialSubParser,ColorMaterialSubParser];
      
      public static const ALL_SHAPES:Array = [PlaneShapeSubParser,ExternalShapeSubParser,CubeShapeSubParser,SphereShapeSubParser,CylinderShapeSubParser];
      
      public static const ALL_ONED_VALUES:Array = [OneDConstValueSubParser,OneDRandomVauleSubParser,OneDCurveValueSubParser];
      
      public static const ALL_THREED_VALUES:Array = [ThreeDConstValueSubParser,ThreeDCompositeValueSubParser,ThreeDSphereValueSubParser,ThreeDCylinderValueSubParser];
      
      public static const ALL_FOURD_VALUES:Array = [FourDCompositeWithOneDValueSubParser,FourDCompositeWithThreeDValueSubParser];
      
      public static const ALL_COLOR_VALUES:Array = [CompositeColorValueSubParser,ParticleSegmentedColorNodeSubParser];
      
      public static const ALL_MATRIX3DS:Array = [Matrix3DCompositeValueSubParser];
      
      public static const ALL_GLOBAL_VALUES:Array = [];
      
      public static const ALL_PROPERTIES:Array = [InstancePropertySubParser];
      
      public function AllSubParsers()
      {
         super();
      }
   }
}

