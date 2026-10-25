package away3d.loaders.parsers.particleSubParsers.values.setters.matrix
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Matrix;
   
   public class Matrix2DUVCompositeSetter extends SetterBase
   {
      
      private var _numColumns:int;
      
      private var _numRows:int;
      
      private var _selectedValue:SetterBase;
      
      public function Matrix2DUVCompositeSetter(param1:String, param2:int, param3:int, param4:SetterBase)
      {
         super(param1);
         this._numColumns = param2;
         this._numRows = param3;
         this._selectedValue = param4;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc3_:Matrix = new Matrix();
         _loc3_.scale(1 / this._numColumns,1 / this._numRows);
         var _loc4_:int = this._selectedValue.generateOneValue(param1,param2) % (this._numColumns * this._numRows);
         var _loc5_:int = _loc4_ / this._numColumns;
         var _loc6_:int = _loc4_ % this._numColumns;
         _loc3_.translate(_loc6_ / this._numColumns,_loc5_ / this._numRows);
         return _loc3_;
      }
      
      override public function startPropsGenerating(param1:ParticleProperties) : void
      {
         this._selectedValue.startPropsGenerating(param1);
      }
      
      override public function finishPropsGenerating(param1:ParticleProperties) : void
      {
         this._selectedValue.finishPropsGenerating(param1);
      }
   }
}

