package net.bigpoint.darkorbit.map.view2D
{
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Program3D;
   import starling.filters.FragmentFilter;
   import starling.textures.Texture;
   
   public class StarlingPixelateFilter2D extends FragmentFilter
   {
      
      private var mQuantifiers:Vector.<Number> = new <Number>[1,1,1,1];
      
      private var mPixelSize:int;
      
      private var mShaderProgram:Program3D;
      
      public function StarlingPixelateFilter2D(param1:int)
      {
         super();
         this.mPixelSize = param1;
      }
      
      override public function dispose() : void
      {
         if(this.mShaderProgram)
         {
            this.mShaderProgram.dispose();
         }
         super.dispose();
      }
      
      override protected function createPrograms() : void
      {
         var _loc1_:String = "div ft0, v0, fc0                                               \n" + "frc ft1, ft0                                                   \n" + "sub ft0, ft0, ft1                                              \n" + "mul ft0, ft0, fc0                                              \n" + "tex oc, ft0, fs0<2d, clamp, nearest>";
         this.mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         this.mQuantifiers[0] = this.mPixelSize / param3.width;
         this.mQuantifiers[1] = this.mPixelSize / param3.height;
         param2.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.mQuantifiers,1);
         param2.setProgram(this.mShaderProgram);
      }
      
      public function get pixelSize() : int
      {
         return this.mPixelSize;
      }
      
      public function set pixelSize(param1:int) : void
      {
         this.mPixelSize = param1;
      }
   }
}

