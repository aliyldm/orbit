package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class UserMessageNoteListCommand implements IModule
   {
      
      private static var _instance:UserMessageNoteListCommand;
      
      public var noteInfoCommandList:Vector.<UserMessageNoteInfoCommand>;
      
      public function UserMessageNoteListCommand(param1:Vector.<UserMessageNoteInfoCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.noteInfoCommandList = new Vector.<UserMessageNoteInfoCommand>();
         }
         else
         {
            this.noteInfoCommandList = param1;
         }
      }
      
      public static function get instance() : UserMessageNoteListCommand
      {
         return _instance || (_instance = new UserMessageNoteListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4898;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UserMessageNoteInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.noteInfoCommandList.length > 0)
         {
            this.noteInfoCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UserMessageNoteInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.noteInfoCommandList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UserMessageNoteInfoCommand = null;
         param1.writeShort(4898);
         param1.writeByte(this.noteInfoCommandList.length);
         for each(_loc2_ in this.noteInfoCommandList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

