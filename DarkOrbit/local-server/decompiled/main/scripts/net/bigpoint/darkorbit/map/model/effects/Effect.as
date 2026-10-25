package net.bigpoint.darkorbit.map.model.effects
{
   import avmplus.getQualifiedClassName;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class Effect
   {
      
      public static const NOT_PERSISTANT:int = 0;
      
      public static const PERSISTANT:int = 1;
      
      public static const TIME_OUT:int = 2;
      
      private var _timerPointer:uint = 0;
      
      private var _id:int;
      
      private var _type:int = 0;
      
      private var _pattern:EffectPattern;
      
      private var _timeOutTime:Number;
      
      protected var _excludeGroup:uint = 0;
      
      public function Effect(param1:int, param2:int, param3:EffectPattern = null)
      {
         super();
         this._id = param1;
         this._type = param2;
         this._pattern = param3 || PatternManager.effectPatterns[param1];
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get pattern() : EffectPattern
      {
         return this._pattern;
      }
      
      public function set pattern(param1:EffectPattern) : void
      {
         this._pattern = param1;
      }
      
      public function get timeOutTime() : Number
      {
         return this._timeOutTime;
      }
      
      public function set timeOutTime(param1:Number) : void
      {
         this._timeOutTime = param1;
      }
      
      public function get excludeGroup() : uint
      {
         return this._excludeGroup;
      }
      
      public function get persistent() : Boolean
      {
         return this._type == PERSISTANT;
      }
      
      public function get timeout() : Boolean
      {
         return this._type == TIME_OUT;
      }
      
      public function activate() : Boolean
      {
         if(this.timeout)
         {
            this.resetTimer();
         }
         return true;
      }
      
      public function reactivate(param1:Effect) : void
      {
         if(this.timeout)
         {
            this.resetTimer();
         }
      }
      
      public function deactivate() : void
      {
         clearTimeout(this._timerPointer);
      }
      
      public function isValid() : Boolean
      {
         return true;
      }
      
      public function toString() : String
      {
         var _loc1_:String = getQualifiedClassName(this);
         _loc1_ = _loc1_.substr(_loc1_.lastIndexOf("::") + 2);
         return _loc1_ + " id: " + this.id + " - type: " + (this.persistent ? "persistant" : (this.timeout ? "timeout" : "notPersistant"));
      }
      
      private function resetTimer() : void
      {
         clearTimeout(this._timerPointer);
         this._timerPointer = setTimeout(this.handleEffectFinished,this._timeOutTime);
      }
      
      private function handleEffectFinished() : void
      {
         ScreenManager.getInstance().map.effects.removeEffect(this);
      }
      
      public function get ignoresCloak() : Boolean
      {
         return false;
      }
   }
}

