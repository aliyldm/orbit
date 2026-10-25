package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WordPuzzleLetterModule implements IModule
   {
      
      private static var _instance:WordPuzzleLetterModule;
      
      public var letterValue:String = "";
      
      public var letterIndex:int = 0;
      
      public function WordPuzzleLetterModule(param1:String = "", param2:int = 0)
      {
         super();
         this.letterValue = param1;
         this.letterIndex = param2;
      }
      
      public static function get instance() : WordPuzzleLetterModule
      {
         return _instance || (_instance = new WordPuzzleLetterModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6279;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.letterValue = param1.readUTF();
         this.letterIndex = param1.readInt();
         this.letterIndex = this.letterIndex >>> 6 % 32 | this.letterIndex << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6279);
         param1.writeUTF(this.letterValue);
         param1.writeInt(this.letterIndex << 6 % 32 | this.letterIndex >>> 32 - 6 % 32);
      }
   }
}

