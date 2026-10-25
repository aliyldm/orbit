package away3d.animators.data
{
   import away3d.core.base.data.ParticleData;
   
   public class ParticleAnimationData
   {
      
      public var index:uint;
      
      public var startTime:Number;
      
      public var totalTime:Number;
      
      public var duration:Number;
      
      public var delay:Number;
      
      public var startVertexIndex:uint;
      
      public var numVertices:uint;
      
      public function ParticleAnimationData(param1:uint, param2:Number, param3:Number, param4:Number, param5:ParticleData)
      {
         super();
         this.index = param1;
         this.startTime = param2;
         this.totalTime = param3 + param4;
         this.duration = param3;
         this.delay = param4;
         this.startVertexIndex = param5.startVertexIndex;
         this.numVertices = param5.numVertices;
      }
   }
}

