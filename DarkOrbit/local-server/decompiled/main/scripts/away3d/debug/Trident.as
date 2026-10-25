package away3d.debug
{
   import away3d.core.base.Geometry;
   import away3d.debug.data.TridentLines;
   import away3d.entities.Mesh;
   import away3d.extrusions.LatheExtrude;
   import away3d.materials.ColorMaterial;
   import away3d.tools.commands.Merge;
   import flash.geom.Vector3D;
   
   public class Trident extends Mesh
   {
      
      public function Trident(param1:Number = 1000, param2:Boolean = true)
      {
         super(new Geometry(),null);
         this.buildTrident(Math.abs(param1 == 0 ? 10 : param1),param2);
      }
      
      private function buildTrident(param1:Number, param2:Boolean) : void
      {
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc3_:Number = param1 * 0.9;
         var _loc4_:Number = 2.4;
         var _loc5_:Number = param1 * 0.025;
         var _loc6_:Vector.<Vector.<Vector3D>> = new Vector.<Vector.<Vector3D>>();
         var _loc7_:Vector.<uint> = Vector.<uint>([16711680,65280,255]);
         var _loc8_:ColorMaterial = new ColorMaterial(16711680);
         var _loc9_:ColorMaterial = new ColorMaterial(65280);
         var _loc10_:ColorMaterial = new ColorMaterial(255);
         var _loc11_:ColorMaterial = new ColorMaterial(13421772);
         var _loc12_:Merge = new Merge(true,true);
         var _loc13_:Vector.<Vector3D> = new Vector.<Vector3D>();
         _loc13_[0] = new Vector3D(param1,0,0);
         _loc13_[1] = new Vector3D(_loc3_,0,_loc5_);
         _loc13_[2] = new Vector3D(_loc3_,0,-_loc4_);
         _loc6_[0] = Vector.<Vector3D>([new Vector3D(0,0,0),new Vector3D(_loc3_,0,0)]);
         var _loc14_:LatheExtrude = new LatheExtrude(_loc8_,_loc13_,LatheExtrude.X_AXIS,1,10);
         var _loc15_:Vector.<Vector3D> = new Vector.<Vector3D>();
         _loc15_[0] = new Vector3D(0,param1,0);
         _loc15_[1] = new Vector3D(_loc5_,_loc3_,0);
         _loc15_[2] = new Vector3D(-_loc4_,_loc3_,0);
         _loc6_[1] = Vector.<Vector3D>([new Vector3D(0,0,0),new Vector3D(0,_loc3_,0)]);
         var _loc16_:LatheExtrude = new LatheExtrude(_loc9_,_loc15_,LatheExtrude.Y_AXIS,1,10);
         var _loc17_:Vector.<Vector3D> = new Vector.<Vector3D>();
         _loc6_[2] = Vector.<Vector3D>([new Vector3D(0,0,0),new Vector3D(0,0,_loc3_)]);
         _loc17_[0] = new Vector3D(0,_loc4_,_loc3_);
         _loc17_[1] = new Vector3D(0,_loc5_,_loc3_);
         _loc17_[2] = new Vector3D(0,0,param1);
         var _loc18_:LatheExtrude = new LatheExtrude(_loc10_,_loc17_,LatheExtrude.Z_AXIS,1,10);
         var _loc19_:Vector.<Vector3D> = new Vector.<Vector3D>();
         _loc19_[0] = new Vector3D(0,_loc4_,0);
         _loc19_[1] = new Vector3D(-(_loc4_ * 0.7),_loc4_ * 0.7,0);
         _loc19_[2] = new Vector3D(-_loc4_,0,0);
         _loc19_[3] = new Vector3D(-(_loc4_ * 0.7),-(_loc4_ * 0.7),0);
         _loc19_[4] = new Vector3D(0,-_loc4_,0);
         var _loc20_:LatheExtrude = new LatheExtrude(_loc11_,_loc19_,LatheExtrude.Y_AXIS,1,10);
         _loc12_.applyToMeshes(this,Vector.<Mesh>([_loc14_,_loc16_,_loc18_,_loc20_]));
         if(param2)
         {
            _loc21_ = param1 / 10;
            _loc22_ = param1 / 20;
            _loc23_ = _loc22_ * 1.5;
            _loc24_ = _loc21_ * 3;
            _loc25_ = _loc21_ * 2;
            _loc26_ = _loc21_ * 3.4;
            _loc27_ = param1 + _loc25_ + (param1 + _loc26_ - (param1 + _loc25_)) / 3 * 2;
            _loc6_[3] = Vector.<Vector3D>([new Vector3D(param1 + _loc24_,_loc23_,0),new Vector3D(param1 + _loc25_,-_loc23_,0),new Vector3D(param1 + _loc25_,_loc23_,0),new Vector3D(param1 + _loc24_,-_loc23_,0)]);
            _loc6_[4] = Vector.<Vector3D>([new Vector3D(-_loc22_ * 1.2,param1 + _loc26_,0),new Vector3D(0,_loc27_,0),new Vector3D(_loc22_ * 1.2,param1 + _loc26_,0),new Vector3D(0,_loc27_,0),new Vector3D(0,_loc27_,0),new Vector3D(0,param1 + _loc25_,0)]);
            _loc6_[5] = Vector.<Vector3D>([new Vector3D(0,_loc23_,param1 + _loc24_),new Vector3D(0,_loc23_,param1 + _loc25_),new Vector3D(0,-_loc23_,param1 + _loc24_),new Vector3D(0,-_loc23_,param1 + _loc25_),new Vector3D(0,-_loc23_,param1 + _loc25_),new Vector3D(0,_loc23_,param1 + _loc24_)]);
            _loc7_.push(16711680,65280,255);
         }
         this.addChild(new TridentLines(_loc6_,_loc7_));
      }
   }
}

