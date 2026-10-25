package net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentInstance;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractLayoutedListBar;
   
   public class FeaturesMenu extends DOAbstractComponentInstance
   {
      
      private static const LINKAGE:String = "featuresMenu";
      
      private static const GAME_FEATURE_BAR:String = "gameFeatureBar";
      
      private static const GENERIC_FEATURE_BAR:String = "genericFeatureBar";
      
      public var gameFeatureBar:FeatureBar;
      
      public var genericFeatureBar:FeatureBar;
      
      public function FeaturesMenu(param1:SWFFinisher)
      {
         super(param1,this.symbolLinkage);
      }
      
      override public function decorate() : void
      {
         addViewChild(this.gameFeatureBar = new FeatureBar(getSpriteChild(GAME_FEATURE_BAR),DOAbstractLayoutedListBar.RIGHT_BUTTONS_ALIGMENT,false));
         addViewChild(this.genericFeatureBar = new FeatureBar(getSpriteChild(GENERIC_FEATURE_BAR),DOAbstractLayoutedListBar.LEFT_BUTTONS_ALIGMENT,false));
         mouseEnabled = false;
      }
      
      override public function updateLayout() : void
      {
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
   }
}

