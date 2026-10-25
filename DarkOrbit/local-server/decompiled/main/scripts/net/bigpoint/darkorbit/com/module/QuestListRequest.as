package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestListRequest implements IModule
   {
      
      private static var _instance:QuestListRequest;
      
      public function QuestListRequest()
      {
         super();
      }
      
      public static function get instance() : QuestListRequest
      {
         return _instance || (_instance = new QuestListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2074;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2074);
      }
   }
}

