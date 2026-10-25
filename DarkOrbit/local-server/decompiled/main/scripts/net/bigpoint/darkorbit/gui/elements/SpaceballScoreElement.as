package net.bigpoint.darkorbit.gui.elements
{
   import flash.display.MovieClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class SpaceballScoreElement extends ScoreElement
   {
      
      private var spaceball_speed:MovieClip;
      
      public function SpaceballScoreElement(param1:GuiManager, param2:int)
      {
         super(TYPE_SPACEBALL_SCORE,param1,param2);
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.spaceball_speed = _loc3_.getEmbeddedMovieClip("spaceball_speed");
         this.spaceball_speed.mouseEnabled = Main.mouseEventsEnabled;
         this.spaceball_speed.mouseChildren = Main.mouseEventsEnabled;
         this.spaceball_speed.gotoAndStop(1);
         this.spaceball_speed.x = 15;
         this.spaceball_speed.y = 29;
         this.addChild(this.spaceball_speed);
      }
      
      public function setSpeed(param1:int) : void
      {
         this.spaceball_speed.gotoAndStop(param1 + 1);
      }
   }
}

