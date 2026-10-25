package net.bigpoint.darkorbit.managers
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.map.model.ship.patterns.EngineSmokePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   
   public class ObjectPoolManager
   {
      
      private static const MAX_SMOKE_POOL_SIZE:int = 120;
      
      public static var engineSmokePool:Array = [];
      
      public static var rocketSmokePool:Array = [];
      
      public static var collectablePool:Array = [];
      
      public static var laserPool:Array = [];
      
      public function ObjectPoolManager()
      {
         super();
      }
      
      public static function precache() : void
      {
      }
      
      public static function init() : void
      {
         var _loc1_:EngineSmokePattern = null;
         var _loc2_:RocketSmokePattern = null;
         for each(_loc1_ in PatternManager.engineSmokePatterns)
         {
            createEngineSmokePool(_loc1_.resKey,_loc1_.poolSize);
         }
         for each(_loc2_ in PatternManager.rocketSmokePatterns)
         {
            createRocketSmokePool(_loc2_.resKey,_loc2_.poolSize);
         }
      }
      
      public static function createEngineSmokePool(param1:String, param2:int) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:BitmapClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
         var _loc4_:Vector.<BitmapClip> = new Vector.<BitmapClip>();
         var _loc7_:int = 0;
         while(_loc7_ < param2)
         {
            _loc5_ = MovieClip(_loc3_.getEmbeddedMovieClip("mc"));
            _loc6_ = new BitmapClip(_loc5_,param1);
            _loc4_.push(_loc6_);
            _loc7_++;
         }
         engineSmokePool[param1] = _loc4_;
      }
      
      public static function getEngineSmokeClip(param1:String) : BitmapClip
      {
         var _loc2_:Vector.<BitmapClip> = engineSmokePool[param1] as Vector.<BitmapClip>;
         if(_loc2_ == null)
         {
            return null;
         }
         return _loc2_.pop();
      }
      
      public static function addEngineSmokeClip(param1:BitmapClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Vector.<BitmapClip> = engineSmokePool[param1.cacheID] as Vector.<BitmapClip>;
         if(_loc2_ == null || _loc2_.indexOf(param1) != -1)
         {
            return;
         }
         if(_loc2_.length >= MAX_SMOKE_POOL_SIZE)
         {
            return;
         }
         resetSmokeClip(param1);
         _loc2_.push(param1);
      }
      
      public static function createLaserPool(param1:String, param2:int) : void
      {
         var _loc5_:MovieClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
         var _loc4_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < param2)
         {
            _loc5_ = MovieClip(_loc3_.getEmbeddedMovieClip("mc"));
            _loc5_.gotoAndStop(1);
            _loc5_.mouseEnabled = false;
            _loc5_.mouseChildren = false;
            _loc4_.push(_loc5_);
            _loc6_++;
         }
         laserPool[param1] = _loc4_;
      }
      
      public static function createRocketSmokePool(param1:String, param2:int) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:BitmapClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
         var _loc4_:Vector.<BitmapClip> = new Vector.<BitmapClip>();
         var _loc7_:int = 0;
         while(_loc7_ < param2)
         {
            _loc5_ = MovieClip(_loc3_.getEmbeddedMovieClip("mc"));
            _loc6_ = new BitmapClip(_loc5_,param1);
            _loc4_.push(_loc6_);
            _loc7_++;
         }
         rocketSmokePool[param1] = _loc4_;
      }
      
      public static function getRocketSmokeClip(param1:String) : BitmapClip
      {
         var _loc2_:Vector.<BitmapClip> = rocketSmokePool[param1] as Vector.<BitmapClip>;
         if(_loc2_ == null)
         {
            return null;
         }
         return _loc2_.pop();
      }
      
      public static function addRocketSmokeClip(param1:BitmapClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Vector.<BitmapClip> = rocketSmokePool[param1.cacheID] as Vector.<BitmapClip>;
         if(_loc2_ == null || _loc2_.indexOf(param1) != -1)
         {
            return;
         }
         if(_loc2_.length >= MAX_SMOKE_POOL_SIZE)
         {
            return;
         }
         resetSmokeClip(param1);
         _loc2_.push(param1);
      }
      
      private static function resetSmokeClip(param1:BitmapClip) : void
      {
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         param1.visible = true;
         param1.alpha = 1;
         param1.x = param1.y = 0;
         param1.rotation = 0;
         param1.scaleX = param1.scaleY = 1;
         param1.transform.colorTransform = new ColorTransform();
      }
      
      public static function createCollectablePool(param1:String, param2:int) : void
      {
         var _loc6_:MovieClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < param2)
         {
            _loc6_ = MovieClip(_loc3_.getEmbeddedMovieClip("mc"));
            _loc6_.mouseEnabled = Main.mouseEventsEnabled;
            _loc6_.mouseChildren = Main.mouseEventsEnabled;
            _loc4_.push(_loc6_);
            _loc5_++;
         }
         collectablePool[param1] = _loc4_;
      }
   }
}

