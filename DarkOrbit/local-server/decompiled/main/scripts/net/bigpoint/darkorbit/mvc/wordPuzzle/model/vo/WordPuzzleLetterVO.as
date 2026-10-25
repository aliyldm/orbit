package net.bigpoint.darkorbit.mvc.wordPuzzle.model.vo
{
   import net.bigpoint.darkorbit.com.module.WordPuzzleLetterModule;
   
   public class WordPuzzleLetterVO
   {
      
      public static const DEFAULT_PLACEHOLDER_LETTER:String = "_";
      
      public static const DEFAULT_GAP_LETTER:String = ".";
      
      public var letterValues:Vector.<WordPuzzleLetterModule>;
      
      public var letterCount:int = 0;
      
      public var letterPlaceHolderLetter:String = "_";
      
      public var complete:Boolean;
      
      protected var letters:Vector.<String>;
      
      public function WordPuzzleLetterVO()
      {
         super();
      }
      
      public function initialize(param1:int) : void
      {
         this.letterCount = param1;
         this.letters = new Vector.<String>(this.letterCount - 1);
         this.fillLetterListWithChar(this.letterPlaceHolderLetter);
      }
      
      protected function fillLetterListWithChar(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.letterCount)
         {
            this.letters[_loc2_] = param1;
            _loc2_++;
         }
      }
      
      public function getWordAsString() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.letterCount)
         {
            _loc1_ += this.letters[_loc2_];
            if(_loc2_ != this.letterCount - 1)
            {
               _loc1_ += DEFAULT_GAP_LETTER;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function setLetter(param1:String, param2:uint) : void
      {
         if(param2 < this.letterCount)
         {
            this.letters[param2] = param1;
         }
      }
      
      public function updateLetters(param1:WordPuzzleLetterVO) : void
      {
         var _loc2_:WordPuzzleLetterModule = null;
         for each(_loc2_ in param1.letterValues)
         {
            this.setLetter(_loc2_.letterValue,_loc2_.letterIndex);
         }
         this.complete = param1.complete;
      }
   }
}

