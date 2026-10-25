package net.bigpoint.darkorbit.map.view2D.starfield
{
   import net.bigpoint.darkorbit.mvc.display.DisplayObjectsBuilder;
   import net.bigpoint.darkorbit.mvc.display.IDODisplayObject;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   
   public class Starfield2D
   {
      
      private var _elementsCount:uint = 100;
      
      private var _fieldWidth:uint = 640;
      
      private var _fieldHeight:uint = 400;
      
      private var _xSpeed:Number = 2;
      
      private var _ySpeed:Number = 1;
      
      private var _container:IDOSprite;
      
      private var _elements:Vector.<IStar>;
      
      private var _builder:DisplayObjectsBuilder;
      
      private var _prev_lookAtWorldX:int;
      
      private var _prev_lookAtWorldY:int;
      
      public function Starfield2D(param1:DisplayObjectsBuilder, param2:uint = 300)
      {
         super();
         this._elementsCount = param2;
         this._fieldHeight = 100;
         this._fieldWidth = 100;
         DisplayObjectsBuilder.starlingViewBuilder.setImplementation(IStar,StarlingStar);
         DisplayObjectsBuilder.flashViewBuilder.setImplementation(IStar,FlashStar);
         this._builder = param1;
         this._container = this._builder.buildSprite();
         this._container["name"] = "starfield";
         this.createStarElements();
      }
      
      public function setViewportSize(param1:uint, param2:uint) : void
      {
         this._fieldWidth = param1;
         this._fieldHeight = param2;
         this.reset();
      }
      
      public function reset() : void
      {
         var _loc1_:IStar = null;
         for each(_loc1_ in this._elements)
         {
            this.setRandomPosition(_loc1_);
         }
      }
      
      protected function removeStarElements() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:IStar = null;
         if(this._elements != null)
         {
            _loc1_ = this._elements.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._elements[_loc2_] as IStar;
               _loc3_.dispose();
               this._container.removeUntypedChild(_loc3_);
               _loc2_++;
            }
            this._elements = null;
         }
      }
      
      public function get container() : IDODisplayObject
      {
         return this._container;
      }
      
      public function update(param1:int, param2:int, param3:int, param4:int, param5:Number) : void
      {
         if(Math.abs(this._prev_lookAtWorldX - param1) <= this._fieldWidth && Math.abs(this._prev_lookAtWorldY - param2) <= this._fieldHeight)
         {
            this.setSpeed(30 * (this._prev_lookAtWorldX - param1),30 * (this._prev_lookAtWorldY - param2));
         }
         this._prev_lookAtWorldX = param1;
         this._prev_lookAtWorldY = param2;
         this.move(param5);
      }
      
      private function setSpeed(param1:Number, param2:Number) : void
      {
         if(param1 == 0 && param2 == 0)
         {
            this._xSpeed = 8;
            this._ySpeed = 4;
         }
         else
         {
            this._xSpeed = param1;
            this._ySpeed = param2;
         }
      }
      
      private function setRandomPosition(param1:IStar) : void
      {
         param1.x = Math.random() * this._fieldWidth;
         param1.y = Math.random() * this._fieldHeight;
      }
      
      private function calculateColor(param1:Number) : uint
      {
         var _loc2_:Number = param1 * 238 + 17;
         return _loc2_ << 16 | _loc2_ << 8 | _loc2_;
      }
      
      private function createStarElements() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:IStar = null;
         if(this._elements)
         {
            this.removeStarElements();
         }
         this._elements = new Vector.<IStar>();
         var _loc1_:int = 0;
         while(_loc1_ < this._elementsCount)
         {
            _loc2_ = _loc1_ / this._elementsCount;
            _loc3_ = _loc2_ * 3 + 0.5;
            _loc4_ = this.calculateColor(_loc2_);
            _loc5_ = this._builder.build(IStar) as IStar;
            _loc5_.speed = _loc3_;
            _loc5_.color = _loc4_;
            this._elements.push(_loc5_);
            this.setRandomPosition(_loc5_);
            this._container.addUntypedChild(_loc5_);
            _loc1_++;
         }
      }
      
      private function move(param1:Number) : void
      {
         var _loc5_:Object = null;
         var _loc2_:Number = this._xSpeed * param1;
         var _loc3_:Number = this._ySpeed * param1;
         var _loc4_:Number = this._elements.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._elements[_loc6_];
            _loc5_.x += _loc5_.speed * _loc2_;
            _loc5_.y += _loc5_.speed * _loc3_;
            if(_loc5_.x < 0)
            {
               _loc5_.x += this._fieldWidth;
            }
            else if(_loc5_.x > this._fieldWidth)
            {
               _loc5_.x -= this._fieldWidth;
            }
            if(_loc5_.y < 0)
            {
               _loc5_.y += this._fieldHeight;
            }
            else if(_loc5_.y > this._fieldHeight)
            {
               _loc5_.y -= this._fieldHeight;
            }
            _loc6_++;
         }
      }
   }
}

