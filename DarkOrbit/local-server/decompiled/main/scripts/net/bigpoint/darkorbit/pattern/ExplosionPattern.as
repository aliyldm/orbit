package net.bigpoint.darkorbit.pattern
{
   public class ExplosionPattern extends AudibleResourcePattern
   {
      
      public static const TYPE_SHIP_EXPLOSION:int = 0;
      
      public static const TYPE_MINE_EXPLOSION:int = 1;
      
      public static const TYPE_LASER_DAMAGE:int = 2;
      
      public static const TYPE_ROCKET_DAMAGE:int = 3;
      
      public static const TYPE_SMARTBOMB_EXPLOSION:int = 4;
      
      public static const TYPE_INSTASHIELD:int = 5;
      
      public static const TYPE_SOUNDWORD:int = 6;
      
      private var _useBitmapClip:Boolean;
      
      private var _shockwaveId:int = -1;
      
      private var _precache:Boolean;
      
      private var _rotatable:Boolean;
      
      private var _scale:Number = 1;
      
      private var _has3D:Boolean = true;
      
      private var _patternClass:int;
      
      public function ExplosionPattern(param1:int, param2:int, param3:String, param4:Boolean)
      {
         super(param2,param3);
         this._patternClass = param1;
         this._has3D = param4;
      }
      
      public function get useBitmapClip() : Boolean
      {
         return this._useBitmapClip;
      }
      
      public function get precache() : Boolean
      {
         return this._precache;
      }
      
      public function get rotatable() : Boolean
      {
         return this._rotatable;
      }
      
      public function get shockwaveId() : int
      {
         return this._shockwaveId;
      }
      
      public function get patternClass() : int
      {
         return this._patternClass;
      }
      
      public function set useBitmapClip(param1:Boolean) : void
      {
         this._useBitmapClip = param1;
      }
      
      public function set precache(param1:Boolean) : void
      {
         this._precache = param1;
      }
      
      public function set rotatable(param1:Boolean) : void
      {
         this._rotatable = param1;
      }
      
      public function set shockwaveId(param1:int) : void
      {
         this._shockwaveId = param1;
      }
      
      public function get has3D() : Boolean
      {
         return this._has3D;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1;
      }
   }
}

