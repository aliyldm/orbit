package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestListUpdateCommand implements IModule
   {
      
      private static var _instance:QuestListUpdateCommand;
      
      public var list:Vector.<QuestSlimInfoModule>;
      
      public function QuestListUpdateCommand(param1:Vector.<QuestSlimInfoModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.list = new Vector.<QuestSlimInfoModule>();
         }
         else
         {
            this.list = param1;
         }
      }
      
      public static function get instance() : QuestListUpdateCommand
      {
         return _instance || (_instance = new QuestListUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12122;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestSlimInfoModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.list.length > 0)
         {
            this.list.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = QuestSlimInfoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.list.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuestSlimInfoModule = null;
         param1.writeShort(12122);
         param1.writeShort(this.list.length);
         for each(_loc2_ in this.list)
         {
            _loc2_.write(param1);
         }
      }
   }
}

