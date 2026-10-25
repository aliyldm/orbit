package net.bigpoint.darkorbit.fui.builder.xml.mapping
{
   import net.bigpoint.darkorbit.fui.builder.xml.creators.AbstractCreator;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.video.VideoChainPlayer;
   
   public class VideoChainPlayerCreator extends AbstractCreator
   {
      
      public function VideoChainPlayerCreator()
      {
         super();
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:VideoChainPlayer = new VideoChainPlayer(param1);
         mapXMLNodeAttributes(_loc2_,param1);
         return _loc2_;
      }
   }
}

