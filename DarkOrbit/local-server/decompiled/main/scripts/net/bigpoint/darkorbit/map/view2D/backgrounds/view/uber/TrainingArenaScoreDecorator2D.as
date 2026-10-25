package net.bigpoint.darkorbit.map.view2D.backgrounds.view.uber
{
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.traits.UberBackgroundDisplayTrait;
   import net.bigpoint.darkorbit.mvc.display.IDOMovieClip;
   import net.bigpoint.darkorbit.mvc.display.IDOTextField;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.VictoryPointsMapAssetElement;
   
   public class TrainingArenaScoreDecorator2D implements IUberBackgroundDecorator3D, IDisposable
   {
      
      private var _view:UberBackgroundElement2D;
      
      private var _trait:UberBackgroundDisplayTrait;
      
      public function TrainingArenaScoreDecorator2D()
      {
         super();
      }
      
      private function get heroDigit2() : IDOMovieClip
      {
         return this._view.descriptor.getViewById("HERO_DIGIT2") as IDOMovieClip;
      }
      
      private function get opponentDigit2() : IDOMovieClip
      {
         return this._view.descriptor.getViewById("OPPONENT_DIGIT2") as IDOMovieClip;
      }
      
      private function get heroDigit1() : IDOMovieClip
      {
         return this._view.descriptor.getViewById("HERO_DIGIT1") as IDOMovieClip;
      }
      
      private function get opponentDigit1() : IDOMovieClip
      {
         return this._view.descriptor.getViewById("OPPONENT_DIGIT1") as IDOMovieClip;
      }
      
      private function get seasonText() : IDOTextField
      {
         return this._view.descriptor.getViewById("text") as IDOTextField;
      }
      
      private function get vo() : VictoryPointsMapAssetElement
      {
         return this._trait.owner as VictoryPointsMapAssetElement;
      }
      
      public function decorateUberAsset(param1:UberBackgroundElement2D, param2:UberBackgroundDisplayTrait) : void
      {
         this._view = param1;
         this._trait = param2;
         this.seasonText.font = Styles.corporateFontExt;
         this.seasonText.fontSize = 16;
         this.seasonText.color = 14050604;
         this.seasonText.autoSize = TextFieldAutoSize.CENTER;
         this.heroDigit1.stop();
         this.heroDigit2.stop();
         this.opponentDigit1.stop();
         this.opponentDigit2.stop();
         if(this.vo)
         {
            this.vo.infoVO.changed.add(this.handlePointsChanged);
            this.handlePointsChanged();
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this.vo)
         {
            this.vo.infoVO.changed.remove(this.handlePointsChanged);
         }
      }
      
      private function handlePointsChanged() : void
      {
         var _loc1_:int = this.vo.data.playerVictoryPoint % 3;
         var _loc2_:int = this.vo.data.opponentVictoryPoint % 3;
         if(this.vo.data.seasonName)
         {
            this.seasonText.text = this.vo.data.seasonName;
         }
         this.heroDigit2.currentFrame = Math.min(_loc1_,this.heroDigit2.numFrames);
         this.opponentDigit2.currentFrame = Math.min(_loc2_,this.opponentDigit2.numFrames);
      }
   }
}

