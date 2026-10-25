package net.bigpoint.darkorbit.map.common
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   
   public class MiniMapViewportBounds extends MapEntity
   {
      
      private var _trait:MiniMapTrait;
      
      public function MiniMapViewportBounds()
      {
         super(Map.NEXT_FREE_ID,new PointLite(0,0));
         this._trait = new MiniMapTrait();
         addTrait(this._trait);
      }
      
      public function setViewport(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         this._trait.setViewport(param1,param2,param3,param4,param5,param6,param7,param8);
      }
   }
}

import flash.display.BlendMode;
import flash.display.Shape;
import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;

class MiniMapTrait extends AbstractMiniMapTrait
{
   
   private var _leftTopX:Number = 0;
   
   private var _leftTopY:Number = 0;
   
   private var _rightTopX:Number = 0;
   
   private var _rightTopY:Number = 0;
   
   private var _rightBottomX:Number = 0;
   
   private var _rightBottomY:Number = 0;
   
   private var _leftBottomX:Number = 0;
   
   private var _leftBottomY:Number = 0;
   
   public function MiniMapTrait()
   {
      super(new Shape(),false,false,-1);
      Shape(_icon).blendMode = BlendMode.INVERT;
   }
   
   public function setViewport(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
   {
      this._leftTopX = param1;
      this._leftTopY = param2;
      this._rightTopX = param3;
      this._rightTopY = param4;
      this._rightBottomX = param5;
      this._rightBottomY = param6;
      this._leftBottomX = param7;
      this._leftBottomY = param8;
      this.update();
   }
   
   override protected function update() : void
   {
      var _loc1_:Shape = _icon as Shape;
      _loc1_.graphics.clear();
      _loc1_.graphics.lineStyle(0.7,13421772,0.5);
      var _loc2_:Number = 0.125;
      _loc1_.graphics.moveTo(this._leftTopX * _scale,this._leftTopY * _scale);
      _loc1_.graphics.lineTo(this._leftTopX * _scale + (this._rightTopX - this._leftTopX) * _loc2_ * _scale,this._leftTopY * _scale - (this._leftTopY - this._rightTopY) * _loc2_ * _scale);
      _loc1_.graphics.moveTo(this._leftTopX * _scale,this._leftTopY * _scale);
      _loc1_.graphics.lineTo(this._leftTopX * _scale - (this._leftTopX - this._leftBottomX) * _loc2_ * _scale,this._leftTopY * _scale - (this._leftTopY - this._leftBottomY) * _loc2_ * _scale);
      _loc1_.graphics.moveTo(this._rightBottomX * _scale,this._rightBottomY * _scale);
      _loc1_.graphics.lineTo(this._rightBottomX * _scale - (this._rightBottomX - this._leftBottomX) * _loc2_ * _scale,this._rightBottomY * _scale - (this._rightBottomY - this._leftBottomY) * _loc2_ * _scale);
      _loc1_.graphics.moveTo(this._rightBottomX * _scale,this._rightBottomY * _scale);
      _loc1_.graphics.lineTo(this._rightBottomX * _scale - (this._rightBottomX - this._rightTopX) * _loc2_ * _scale,this._rightBottomY * _scale + (this._rightTopY - this._rightBottomY) * _loc2_ * _scale);
      _loc1_.graphics.moveTo(this._rightTopX * _scale,this._rightTopY * _scale);
      _loc1_.graphics.lineTo(this._rightTopX * _scale - (this._rightTopX - this._leftTopX) * _loc2_ * _scale,this._rightTopY * _scale - (this._rightTopY - this._leftTopY) * _loc2_ * _scale);
      _loc1_.graphics.moveTo(this._rightTopX * _scale,this._rightTopY * _scale);
      _loc1_.graphics.lineTo(this._rightTopX * _scale - (this._rightTopX - this._rightBottomX) * _loc2_ * _scale,this._rightTopY * _scale - (this._rightTopY - this._rightBottomY) * _loc2_ * _scale);
      _loc1_.graphics.moveTo(this._leftBottomX * _scale,this._leftBottomY * _scale);
      _loc1_.graphics.lineTo(this._leftBottomX * _scale - (this._leftBottomX - this._rightBottomX) * _loc2_ * _scale,this._leftBottomY * _scale - (this._leftBottomY - this._rightBottomY) * _loc2_ * _scale);
      _loc1_.graphics.moveTo(this._leftBottomX * _scale,this._leftBottomY * _scale);
      _loc1_.graphics.lineTo(this._leftBottomX * _scale - (this._leftBottomX - this._leftTopX) * _loc2_ * _scale,this._leftBottomY * _scale - (this._leftBottomY - this._leftTopY) * _loc2_ * _scale);
   }
}
