package away3d.materials
{
   import away3d.materials.passes.SegmentPass;
   
   public class SegmentMaterial extends MaterialBase
   {
      
      private var _screenPass:SegmentPass;
      
      public function SegmentMaterial(param1:Number = 1.25)
      {
         super();
         bothSides = true;
         addPass(this._screenPass = new SegmentPass(param1));
         this._screenPass.material = this;
      }
   }
}

