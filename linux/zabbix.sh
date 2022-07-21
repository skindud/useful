


#https://galaxy.ansible.com/community/zabbix

---
- name: Using Zabbix collection
  hosts: localhost
  collections:
    - community.zabbix

  roles:
    - role: zabbix_agent
      zabbix_agent_server: zabbix.example.com