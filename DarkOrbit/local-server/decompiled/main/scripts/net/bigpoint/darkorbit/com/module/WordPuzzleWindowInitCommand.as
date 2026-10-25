package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WordPuzzleWindowInitCommand implements IModule
   {
      
      private static var _instance:WordPuzzleWindowInitCommand;
      
      public var letterCount:int = 0;
      
      public function WordPuzzleWindowInitCommand(param1:int = 0)
      {
         super();
         this.letterCount = param1;
      }
      
      public static function get instance() : WordPuzzleWindowInitCommand
      {
         return _instance || (_instance = new WordPuzzleWindowInitCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6278;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.letterCount = param1.readInt();
         this.letterCount = this.letterCount >>> 11 % 32 | this.letterCount << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6278);
         param1.writeInt(this.letterCount << 11 % 32 | this.letterCount >>> 32 - 11 % 32);
      }
   }
}

