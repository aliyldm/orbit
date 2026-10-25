package away3d.animators.data
{
   public class UVAnimationFrame
   {
      
      public var offsetU:Number;
      
      public var offsetV:Number;
      
      public var scaleU:Number;
      
      public var scaleV:Number;
      
      public var rotation:Number;
      
      public function UVAnimationFrame(param1:Number = 0, param2:Number = 0, param3:Number = 1, param4:Number = 1, param5:Number = 0)
      {
         super();
         this.offsetU = param1;
         this.offsetV = param2;
         this.scaleU = param3;
         this.scaleV = param4;
         this.rotation = param5;
      }
   }
}

