package net.bigpoint.darkorbit.map.view2D.effects
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   
   public class NativeEffectClipPool2D
   {
      
      private static var generation:uint;
      
      private static var count:int;
      
      private static const MAX_IDLE:int = 96;
      
      private static const MAX_PER_CLASS:int = 12;
      
      private static var idle:Dictionary = new Dictionary();
      
      private static var leases:Dictionary = new Dictionary(true);
      
      public function NativeEffectClipPool2D()
      {
         super();
      }
      
      public static function acquire(param1:SWFFinisher, param2:String) : MovieClip
      {
         return acquireSymbol(param1,param2,"mc");
      }
      
      public static function acquireSymbol(param1:SWFFinisher, param2:String, param3:String) : MovieClip
      {
         var _loc6_:MovieClip = null;
         if(!param1)
         {
            return null;
         }
         if(!param2 || param2.indexOf("cannon_") != 0 && param2.indexOf("drive_") != 0 && param2 != "shockwaves")
         {
            return param1.getEmbeddedMovieClip(param3);
         }
         var _loc4_:Class = param1.getClassRefeference(param3);
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:Array = idle[_loc4_];
         if((Boolean(_loc5_)) && Boolean(_loc5_.length))
         {
            _loc6_ = _loc5_.pop();
            --count;
         }
         else
         {
            _loc6_ = param1.getEmbeddedMovieClip(param3);
         }
         if(_loc6_)
         {
            leases[_loc6_] = {
               "definition":_loc4_,
               "generation":generation
            };
         }
         return _loc6_;
      }
      
      public static function release(param1:MovieClip) : void
      {
         var _loc3_:Array = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:Object = leases[param1];
         if(!_loc2_)
         {
            return;
         }
         delete leases[param1];
         param1.addFrameScript(param1.totalFrames - 1,null);
         param1.stop();
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         if(_loc2_.generation != generation)
         {
            return;
         }
         _loc3_ = idle[_loc2_.definition];
         if(!_loc3_)
         {
            idle[_loc2_.definition] = _loc3_ = [];
         }
         if(count >= MAX_IDLE || _loc3_.length >= MAX_PER_CLASS)
         {
            return;
         }
         param1.transform.matrix3D = null;
         param1.transform.matrix = new Matrix();
         param1.transform.colorTransform = new ColorTransform();
         param1.alpha = 1;
         param1.visible = true;
         param1.filters = [];
         param1.blendMode = "normal";
         param1.mask = null;
         param1.scrollRect = null;
         param1.cacheAsBitmap = false;
         param1.gotoAndStop(1);
         _loc3_.push(param1);
         ++count;
      }
      
      public static function clear() : void
      {
         ++generation;
         idle = new Dictionary();
         count = 0;
      }
   }
}

