package away3d.loaders.parsers.particleSubParsers.values.setters.oneD
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   
   public class OneDCurveSetter extends SetterBase
   {
      
      protected var _anchors:Vector.<Anchor>;
      
      public function OneDCurveSetter(param1:String, param2:Array)
      {
         var _loc4_:int = 0;
         super(param1);
         var _loc3_:int = int(param2.length);
         this._anchors = new Vector.<Anchor>(_loc3_,true);
         while(_loc4_ < _loc3_)
         {
            this._anchors[_loc4_] = new Anchor(param2[_loc4_].x,param2[_loc4_].y,param2[_loc4_].type);
            _loc4_++;
         }
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc4_:int = 0;
         var _loc3_:Number = param1 / param2;
         for(; _loc4_ < this._anchors.length - 1; _loc4_++)
         {
            if(this._anchors[_loc4_ + 1].x <= _loc3_)
            {
               continue;
            }
            switch(this._anchors[_loc4_].type)
            {
               case Anchor.LINEAR:
                  return this._anchors[_loc4_].y + (_loc3_ - this._anchors[_loc4_].x) / (this._anchors[_loc4_ + 1].x - this._anchors[_loc4_].x) * (this._anchors[_loc4_ + 1].y - this._anchors[_loc4_].y);
               case Anchor.CONST:
                  return this._anchors[_loc4_].y;
            }
         }
         return this._anchors[_loc4_].y;
      }
   }
}

class Anchor
{
   
   public static const LINEAR:int = 0;
   
   public static const CONST:int = 1;
   
   public static const BEZIER:int = 2;
   
   public var x:Number;
   
   public var y:Number;
   
   public var type:int;
   
   public function Anchor(param1:Number, param2:Number, param3:int)
   {
      super();
      this.x = param1;
      this.y = param2;
      this.type = param3;
   }
}
