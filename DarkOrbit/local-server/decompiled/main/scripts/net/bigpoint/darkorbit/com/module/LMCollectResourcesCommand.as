package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMCollectResourcesCommand implements IModule
   {
      
      private static var _instance:LMCollectResourcesCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var contentList:Vector.<OreCountModule>;
      
      public function LMCollectResourcesCommand(param1:LogMessengerPriorityModule = null, param2:Vector.<OreCountModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.priorityMode = new LogMessengerPriorityModule();
         }
         else
         {
            this.priorityMode = param1;
         }
         if(param2 == null)
         {
            this.contentList = new Vector.<OreCountModule>();
         }
         else
         {
            this.contentList = param2;
         }
      }
      
      public static function get instance() : LMCollectResourcesCommand
      {
         return _instance || (_instance = new LMCollectResourcesCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 203;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:OreCountModule = null;
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.contentList.length > 0)
         {
            this.contentList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = OreCountModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.contentList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:OreCountModule = null;
         param1.writeShort(203);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.contentList.length);
         for each(_loc2_ in this.contentList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

