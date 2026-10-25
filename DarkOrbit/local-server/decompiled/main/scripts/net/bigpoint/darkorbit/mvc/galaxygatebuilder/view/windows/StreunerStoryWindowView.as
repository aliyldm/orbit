package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows
{
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class StreunerStoryWindowView extends AbstractStoryWindowView
   {
      
      public function StreunerStoryWindowView(param1:GalaxyGateBuilderModel, param2:Object = null)
      {
         super(ApplicationEvent.STATE_STREUNER,"teaser_13","title_streunergate_info","msg_streunergate_info",param1,param2,param1.streunerAssets);
      }
   }
}

