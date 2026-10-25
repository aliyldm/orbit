package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WordPuzzleLetterAchievedCommand implements IModule
   {
      
      private static var _instance:WordPuzzleLetterAchievedCommand;
      
      public var letterValues:Vector.<WordPuzzleLetterModule>;
      
      public var complete:Boolean = false;
      
      public function WordPuzzleLetterAchievedCommand(param1:Vector.<WordPuzzleLetterModule> = null, param2:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.letterValues = new Vector.<WordPuzzleLetterModule>();
         }
         else
         {
            this.letterValues = param1;
         }
         this.complete = param2;
      }
      
      public static function get instance() : WordPuzzleLetterAchievedCommand
      {
         return _instance || (_instance = new WordPuzzleLetterAchievedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6277;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:WordPuzzleLetterModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.letterValues.length > 0)
         {
            this.letterValues.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = WordPuzzleLetterModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.letterValues.push(_loc4_);
            _loc2_++;
         }
         this.complete = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:WordPuzzleLetterModule = null;
         param1.writeShort(6277);
         param1.writeByte(this.letterValues.length);
         for each(_loc2_ in this.letterValues)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.complete);
      }
   }
}

