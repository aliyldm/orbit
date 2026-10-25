package net.bigpoint.darkorbit.map.view2D.effects
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   
   public class ImpactFrames2D
   {
      
      private static var templates:Object = {};
      
      private static var estimatedBytes:Number = 0;
      
      public function ImpactFrames2D()
      {
         super();
      }
      
      public static function clear() : void
      {
         templates = {};
         estimatedBytes = 0;
      }
      
      public static function supports(param1:String) : Boolean
      {
         return param1 == "rocketDamage1" || param1 == "laserDamage1";
      }
      
      public static function create(param1:SWFFinisher, param2:String) : DisplayObject
      {
         var copy:BitmapClip;
         var source:MovieClip = null;
         var bounds:Rectangle = null;
         var estimate:Number = NaN;
         var finisher:SWFFinisher = param1;
         var key:String = param2;
         var template:BitmapClip = templates[key] as BitmapClip;
         if(!template)
         {
            source = finisher.getEmbeddedMovieClip("mc");
            bounds = source.getBounds(source);
            estimate = Math.ceil(bounds.width) * Math.ceil(bounds.height) * 4 * source.totalFrames;
            if(!supports(key) || estimate <= 0 || estimatedBytes + estimate > 16 * 1024 * 1024)
            {
               return source;
            }
            try
            {
               template = new BitmapClip(source,"impact-video-frames-v1:" + key);
               template.gotoAndStop(1);
               templates[key] = template;
               estimatedBytes += estimate;
            }
            catch(error:Error)
            {
               source.gotoAndStop(1);
               return source;
            }
         }
         copy = template.clone() as BitmapClip;
         copy.gotoAndStop(1);
         return copy;
      }
   }
}

