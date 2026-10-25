package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.ClanRelationModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryAttributeBaseModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryAttributeClanRelationModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryAttributeClanTagModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryAttributeLevelModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryAttributeMapModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryAttributeNameModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryAttributeOnlineModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryModule;
   import net.bigpoint.darkorbit.com.module.ContactListEntryTypeModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.ContactsWindowProxy;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   
   public class ContactListConvertingAbstractCommand extends DOAbstractSimpleCommand
   {
      
      public function ContactListConvertingAbstractCommand()
      {
         super();
         this.throwAnErrorIfAbstract();
      }
      
      protected function throwAnErrorIfAbstract() : void
      {
         throw new Error("Tried to instatiate abstract Command! " + this);
      }
      
      protected function convertModuleEntryVectorIntoContactlistEntryVO(param1:Vector.<ContactListEntryModule>) : Vector.<ContactsWindowContactListEntryVO>
      {
         var _loc3_:ContactListEntryModule = null;
         var _loc4_:ContactsWindowContactListEntryVO = null;
         var _loc5_:ContactsWindowProxy = null;
         var _loc6_:uint = 0;
         var _loc2_:Vector.<ContactsWindowContactListEntryVO> = new Vector.<ContactsWindowContactListEntryVO>();
         for each(_loc3_ in param1)
         {
            _loc5_ = retrieveProxy(ContactsWindowProxy.NAME) as ContactsWindowProxy;
            if(_loc3_.attributeCommand)
            {
               _loc6_ = uint(_loc3_.attributeCommand.userId);
            }
            if(_loc6_ == 0 && Boolean(_loc3_.typeCommand))
            {
               _loc6_ = uint(_loc3_.typeCommand.userId);
            }
            if(_loc6_ > 0)
            {
               _loc4_ = _loc5_.getListEntryByUserID(_loc6_);
            }
            if(_loc4_ == null)
            {
               _loc4_ = new ContactsWindowContactListEntryVO();
            }
            if(Boolean(_loc3_.attributeCommand) && _loc3_.attributeCommand.userId != 0)
            {
               this.handleAttributeCommand(_loc4_,_loc3_);
            }
            if(Boolean(_loc3_.typeCommand) && _loc3_.typeCommand.userId != 0)
            {
               this.handleTypeCommand(_loc4_,_loc3_);
            }
            _loc4_.updateShownState();
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      private function handleTypeCommand(param1:ContactsWindowContactListEntryVO, param2:ContactListEntryModule) : void
      {
         var _loc4_:ContactListEntryTypeModule = null;
         var _loc5_:Function = null;
         param1.userID = param2.typeCommand.userId;
         param1.isClanmember = false;
         param1.clearStateList();
         var _loc3_:Dictionary = new Dictionary();
         _loc3_[ContactListEntryTypeModule.CONTACTLISTENTRYTYPE_BLOCKED_CONTACT] = this.handleTypeCommand__blockedContact;
         _loc3_[ContactListEntryTypeModule.CONTACTLISTENTRYTYPE_CLAN_MEMBER] = this.handleTypeCommand__clanMember;
         _loc3_[ContactListEntryTypeModule.CONTACTLISTENTRYTYPE_FRIEND] = this.handleTypeCommand__friend;
         _loc3_[ContactListEntryTypeModule.CONTACTLISTENTRYTYPE_INCOMING_REQUEST] = this.handleTypeCommand__incomingPending;
         _loc3_[ContactListEntryTypeModule.CONTACTLISTENTRYTYPE_OUTGOUING_REQUEST_PENDING] = this.handleTypeCommand__outgoingRequestPending;
         _loc3_[ContactListEntryTypeModule.CONTACTLISTENTRYTYPE_OUTGOUING_REQUEST_DECLINED] = this.handleTypeCommand__outgoingRequestDeclined;
         for each(_loc4_ in param2.typeCommand.contactEntryTypes)
         {
            _loc5_ = _loc3_[_loc4_.entryType];
            if(_loc5_ != null)
            {
               _loc5_(param1);
            }
         }
      }
      
      protected function handleTypeCommand__blockedContact(param1:ContactsWindowContactListEntryVO) : void
      {
         param1.addStateToList(ContactsWindowContactListEntryVO.STATE_BLOCK);
      }
      
      protected function handleTypeCommand__clanMember(param1:ContactsWindowContactListEntryVO) : void
      {
         param1.isClanmember = true;
      }
      
      protected function handleTypeCommand__friend(param1:ContactsWindowContactListEntryVO) : void
      {
         param1.addStateToList(ContactsWindowContactListEntryVO.STATE_FRIEND);
      }
      
      protected function handleTypeCommand__incomingPending(param1:ContactsWindowContactListEntryVO) : void
      {
         param1.addStateToList(ContactsWindowContactListEntryVO.STATE_PENDING);
      }
      
      protected function handleTypeCommand__outgoingRequestPending(param1:ContactsWindowContactListEntryVO) : void
      {
         param1.addStateToList(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_PENDING);
      }
      
      protected function handleTypeCommand__outgoingRequestDeclined(param1:ContactsWindowContactListEntryVO) : void
      {
         param1.addStateToList(ContactsWindowContactListEntryVO.STATE_OUTGOING_REQUEST_DECLINED);
      }
      
      private function handleAttributeCommand(param1:ContactsWindowContactListEntryVO, param2:ContactListEntryModule) : void
      {
         var _loc3_:ContactListEntryAttributeBaseModule = null;
         var _loc4_:ClanRelationModule = null;
         var _loc5_:uint = 0;
         param1.userID = param2.attributeCommand.userId;
         for each(_loc3_ in param2.attributeCommand.attributes)
         {
            switch(_loc3_.getLibcomModuleId())
            {
               case ContactListEntryAttributeNameModule.instance.getLibcomModuleId():
                  param1.username = (_loc3_ as ContactListEntryAttributeNameModule).userName;
                  break;
               case ContactListEntryAttributeOnlineModule.instance.getLibcomModuleId():
                  param1.online = (_loc3_ as ContactListEntryAttributeOnlineModule).online;
                  break;
               case ContactListEntryAttributeMapModule.instance.getLibcomModuleId():
                  param1.mapID = (_loc3_ as ContactListEntryAttributeMapModule).currentMap;
                  break;
               case ContactListEntryAttributeLevelModule.instance.getLibcomModuleId():
                  param1.level = (_loc3_ as ContactListEntryAttributeLevelModule).level;
                  break;
               case ContactListEntryAttributeClanTagModule.instance.getLibcomModuleId():
                  param1.clanTag = (_loc3_ as ContactListEntryAttributeClanTagModule).clanTag;
                  break;
               case ContactListEntryAttributeClanRelationModule.instance.getLibcomModuleId():
                  _loc4_ = (_loc3_ as ContactListEntryAttributeClanRelationModule).clanRelation;
                  _loc5_ = uint(_loc4_.type);
                  switch(_loc5_)
                  {
                     case ClanRelationModule.TYPE_AT_WAR:
                        param1.clanRelation = ContactsWindowContactListEntryVO.CLAN_ENEMY;
                        break;
                     case ClanRelationModule.TYPE_ALLIED:
                        param1.clanRelation = ContactsWindowContactListEntryVO.CLAN_FRIENDLY;
                        break;
                     case ClanRelationModule.TYPE_NONE:
                        param1.clanRelation = ContactsWindowContactListEntryVO.CLAN_NONE;
                        break;
                     case ClanRelationModule.TYPE_NON_AGGRESSION_PACT:
                        param1.clanRelation = ContactsWindowContactListEntryVO.CLAN_MINE;
                  }
            }
         }
      }
   }
}

